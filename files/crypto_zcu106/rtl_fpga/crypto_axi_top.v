// =============================================================================
// crypto_axi_top.v
// AXI4-Lite peripheral wrapping the crypto chip for FPGA validation.
//
// This is FPGA-only scaffolding. chip_top and everything below it is the ASIC
// deliverable and is instantiated here completely unmodified.
//
//   PS  --AXI4-Lite-->  register file  -->  spi_master_lite  --SPI-->  chip_top
//                            |                                            |
//                            +------------- status ---------------------- +
//                            |
//                            +--> status_led --> board LEDs
//
// -----------------------------------------------------------------------------
// REGISTER MAP (offsets from the base address assigned in the block design)
//
//   0x00  ID       RO  32'h5AA5C0DE
//                      Read this first. If it comes back correct, the AXI
//                      path, address map, clock and bitstream are all good,
//                      which separates infrastructure problems from logic
//                      problems on day one.
//
//   0x04  CTRL     RW  [0]     cs_n     drive chip select (1 = idle, 0 = active)
//                      [15:8]  sclk_div system clocks per SCLK half period
//                                       f_SCLK = f_clk / (2 * sclk_div)
//                                       must be >= 4; 8 is the recommended
//                                       default and gives f_clk / 16
//
//   0x08  XFER     WO  [7:0]   write a byte to start one SPI transfer
//                  RO  [7:0]   byte received during the last transfer
//                      [8]     spi_busy
//
//   0x0C  STATUS   RO  [0]     spi_busy      master still shifting
//                      [1]     chip_busy     chip mid-transaction
//                      [2]     result_ready  result staged, safe to read back
//                      [3]     chip_err      bad command, bad length, timeout
//
//   0x10  LED      RW  [1:0]   00 idle, 01 pass, 10 fail, 11 running
//
//   0x14  BTN      RO  [1:0]   live debounced button state
//                      [3:2]   latched event code: 01 = W (Ascon),
//                              10 = E (SHA-256), 11 = both
//                      [4]     event pending
//                      [9:8]   RAW pin state, before polarity normalisation
//                              (use this to confirm button polarity on the
//                               bench: press a button and see which way it
//                               moves)
//                  WO  [4]     write 1 to acknowledge and clear the event
//
// -----------------------------------------------------------------------------
// USAGE SEQUENCE (see the Vitis application for the concrete code)
//   1. write CTRL   = {sclk_div, cs_n=1}
//   2. write CTRL.cs_n = 0                       open the frame
//   3. write XFER per byte, polling spi_busy      send the command packet
//   4. write CTRL.cs_n = 1                       close the frame
//   5. poll STATUS.result_ready
//   6. write CTRL.cs_n = 0, send 32 dummy bytes, read XFER after each
//   7. write CTRL.cs_n = 1
// =============================================================================

module crypto_axi_top #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 5,
    parameter integer CLK_HZ             = 100_000_000
) (
    // ---- AXI4-Lite slave ----
    // Several AXI signals are intentionally unused by this peripheral:
    //   awprot / arprot  no protection-level checking is performed
    //   wdata[31:16]     no register is wider than 16 bits
    //   wstrb[3:2]       only byte lanes 0 and 1 carry register fields
    //   awaddr/araddr[1:0]  byte lanes within a 32-bit word; register select
    //                       uses addr[4:2]
    // This is normal for a lightweight AXI4-Lite slave and is flagged here so
    // the block is not mistaken for an incomplete implementation.
    /* verilator lint_off UNUSEDSIGNAL */
    input  wire                                s_axi_aclk,
    input  wire                                s_axi_aresetn,

    input  wire [C_S_AXI_ADDR_WIDTH-1:0]       s_axi_awaddr,
    input  wire [2:0]                          s_axi_awprot,
    input  wire                                s_axi_awvalid,
    output wire                                s_axi_awready,

    input  wire [C_S_AXI_DATA_WIDTH-1:0]       s_axi_wdata,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]   s_axi_wstrb,
    input  wire                                s_axi_wvalid,
    output wire                                s_axi_wready,

    output wire [1:0]                          s_axi_bresp,
    output wire                                s_axi_bvalid,
    input  wire                                s_axi_bready,

    input  wire [C_S_AXI_ADDR_WIDTH-1:0]       s_axi_araddr,
    input  wire [2:0]                          s_axi_arprot,
    input  wire                                s_axi_arvalid,
    output wire                                s_axi_arready,

    output wire [C_S_AXI_DATA_WIDTH-1:0]       s_axi_rdata,
    output wire [1:0]                          s_axi_rresp,
    output wire                                s_axi_rvalid,
    input  wire                                s_axi_rready,

    // ---- Board pushbuttons (ZCU106 5-way switch) ----
    // btn[0] = GPIO_SW_W  -> run the Ascon-128 vectors
    // btn[1] = GPIO_SW_E  -> run the SHA-256 vectors
    // both within a quarter second -> run everything
    input  wire [1:0]                          btn,

    // ---- Board LEDs ----
    output wire                                led_pass,
    output wire                                led_fail
);
    /* verilator lint_on UNUSEDSIGNAL */

    localparam [31:0] ID_MAGIC = 32'h5AA5C0DE;

    // AXI4-Lite is word addressed; with a 32-bit bus the low 2 bits are byte
    // lanes, so register selection uses addr[4:2].
    localparam ADDR_LSB = 2;

    wire clk = s_axi_aclk;

    // =========================================================================
    // Reset synchronizer: assert asynchronously, release synchronously.
    //
    // The PS peripheral reset is asynchronous to the PL clock. Releasing it
    // directly lets different parts of the design leave reset on different
    // clock edges, which produces intermittent, hard-to-reproduce start-up
    // failures on the board. This two-flop synchronizer removes that: the
    // reset still asserts immediately, but the release is aligned to clk.
    //
    // Everything below then uses ONE reset with ONE style (async assert), the
    // same style chip_top uses internally. Mixing synchronous and
    // asynchronous reset on the same net is worse than either on its own.
    // =========================================================================
    (* ASYNC_REG = "TRUE" *) reg rst_meta;
    (* ASYNC_REG = "TRUE" *) reg rst_sync_n;

    always @(posedge clk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            rst_meta   <= 1'b0;
            rst_sync_n <= 1'b0;
        end else begin
            rst_meta   <= 1'b1;
            rst_sync_n <= rst_meta;
        end
    end

    wire rst_n = rst_sync_n;

    // =========================================================================
    // AXI4-Lite slave interface
    // Standard handshake structure: no combinational path from any *ready
    // back to the corresponding *valid.
    // =========================================================================
    reg                             axi_awready;
    reg                             axi_wready;
    reg [1:0]                       axi_bresp;
    reg                             axi_bvalid;
    reg                             axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1:0]    axi_rdata;
    reg [1:0]                       axi_rresp;
    reg                             axi_rvalid;
    // Bits [1:0] select a byte lane within the 32-bit word and are not used;
    // register selection uses addr[4:2].
    /* verilator lint_off UNUSEDSIGNAL */
    reg [C_S_AXI_ADDR_WIDTH-1:0]    axi_awaddr_r;
    reg [C_S_AXI_ADDR_WIDTH-1:0]    axi_araddr_r;
    /* verilator lint_on UNUSEDSIGNAL */
    reg                             aw_en;

    assign s_axi_awready = axi_awready;
    assign s_axi_wready  = axi_wready;
    assign s_axi_bresp   = axi_bresp;
    assign s_axi_bvalid  = axi_bvalid;
    assign s_axi_arready = axi_arready;
    assign s_axi_rdata   = axi_rdata;
    assign s_axi_rresp   = axi_rresp;
    assign s_axi_rvalid  = axi_rvalid;

    // ---- write address ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            axi_awready  <= 1'b0;
            aw_en        <= 1'b1;
            axi_awaddr_r <= {C_S_AXI_ADDR_WIDTH{1'b0}};
        end else begin
            if (!axi_awready && s_axi_awvalid && s_axi_wvalid && aw_en) begin
                axi_awready  <= 1'b1;
                aw_en        <= 1'b0;
                axi_awaddr_r <= s_axi_awaddr;
            end else if (s_axi_bready && axi_bvalid) begin
                axi_awready <= 1'b0;
                aw_en       <= 1'b1;
            end else begin
                axi_awready <= 1'b0;
            end
        end
    end

    // ---- write data ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            axi_wready <= 1'b0;
        else if (!axi_wready && s_axi_wvalid && s_axi_awvalid && aw_en)
            axi_wready <= 1'b1;
        else
            axi_wready <= 1'b0;
    end

    wire slv_wren = axi_wready && s_axi_wvalid && axi_awready && s_axi_awvalid;

    // ---- write response ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            axi_bvalid <= 1'b0;
            axi_bresp  <= 2'b00;
        end else begin
            if (axi_awready && s_axi_awvalid && !axi_bvalid &&
                axi_wready  && s_axi_wvalid) begin
                axi_bvalid <= 1'b1;
                axi_bresp  <= 2'b00;               // OKAY
            end else if (s_axi_bready && axi_bvalid) begin
                axi_bvalid <= 1'b0;
            end
        end
    end

    // ---- read address ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            axi_arready  <= 1'b0;
            axi_araddr_r <= {C_S_AXI_ADDR_WIDTH{1'b0}};
        end else begin
            if (!axi_arready && s_axi_arvalid) begin
                axi_arready  <= 1'b1;
                axi_araddr_r <= s_axi_araddr;
            end else begin
                axi_arready <= 1'b0;
            end
        end
    end

    // ---- read response ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            axi_rvalid <= 1'b0;
            axi_rresp  <= 2'b00;
        end else begin
            if (axi_arready && s_axi_arvalid && !axi_rvalid) begin
                axi_rvalid <= 1'b1;
                axi_rresp  <= 2'b00;               // OKAY
            end else if (axi_rvalid && s_axi_rready) begin
                axi_rvalid <= 1'b0;
            end
        end
    end

    wire slv_rden = axi_arready && s_axi_arvalid && !axi_rvalid;

    // =========================================================================
    // Register file
    // =========================================================================
    reg        cs_n_r;
    reg [7:0]  sclk_div_r;
    reg [7:0]  tx_data_r;
    reg        spi_start;
    reg [1:0]  led_status_r;
    reg [1:0]  btn_evt_code_r;
    reg        btn_evt_pending;

    wire [1:0] btn_state;
    wire [1:0] btn_evt_code;
    wire       btn_evt_valid;

    wire [7:0] spi_rx_data;
    wire       spi_busy;
    wire       chip_busy, chip_result_ready, chip_err;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cs_n_r       <= 1'b1;         // frame closed out of reset
            sclk_div_r   <= 8'd8;         // f_clk / 16, comfortably within spec
            tx_data_r    <= 8'd0;
            spi_start    <= 1'b0;
            led_status_r <= 2'b00;
            btn_evt_code_r  <= 2'b00;
            btn_evt_pending <= 1'b0;
        end else begin
            spi_start <= 1'b0;            // single-cycle pulse

            // A new press always wins over a simultaneous software
            // acknowledge, so an event can never be silently dropped.
            if (btn_evt_valid) begin
                btn_evt_code_r  <= btn_evt_code;
                btn_evt_pending <= 1'b1;
            end

            if (slv_wren) begin
                case (axi_awaddr_r[ADDR_LSB+2:ADDR_LSB])
                    3'd1: begin                       // 0x04 CTRL
                        if (s_axi_wstrb[0]) cs_n_r     <= s_axi_wdata[0];
                        if (s_axi_wstrb[1]) sclk_div_r <= s_axi_wdata[15:8];
                    end
                    3'd2: begin                       // 0x08 XFER
                        if (s_axi_wstrb[0]) begin
                            tx_data_r <= s_axi_wdata[7:0];
                            spi_start <= 1'b1;
                        end
                    end
                    3'd4: begin                       // 0x10 LED
                        if (s_axi_wstrb[0]) led_status_r <= s_axi_wdata[1:0];
                    end
                    3'd5: begin                       // 0x14 BTN (acknowledge)
                        if (s_axi_wstrb[0] && s_axi_wdata[4] && !btn_evt_valid)
                            btn_evt_pending <= 1'b0;
                    end
                    default: ;                        // ID is read-only
                endcase
            end
        end
    end

    // ---- read mux ----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            axi_rdata <= {C_S_AXI_DATA_WIDTH{1'b0}};
        end else if (slv_rden) begin
            case (axi_araddr_r[ADDR_LSB+2:ADDR_LSB])
                3'd0: axi_rdata <= ID_MAGIC;
                3'd1: axi_rdata <= {16'd0, sclk_div_r, 7'd0, cs_n_r};
                3'd2: axi_rdata <= {23'd0, spi_busy, spi_rx_data};
                3'd3: axi_rdata <= {28'd0, chip_err, chip_result_ready,
                                           chip_busy, spi_busy};
                3'd4: axi_rdata <= {30'd0, led_status_r};
                3'd5: axi_rdata <= {22'd0, btn,              // [9:8] raw pins
                                           3'd0,
                                           btn_evt_pending,  // [4]
                                           btn_evt_code_r,   // [3:2]
                                           btn_state};       // [1:0]
                default: axi_rdata <= 32'd0;
            endcase
        end
    end

    // =========================================================================
    // SPI master and the chip under test
    // =========================================================================
    wire sclk_w, mosi_w, miso_w;

    spi_master_lite u_spi_master (
        .clk      (clk),
        .rst_n    (rst_n),
        .sclk_div (sclk_div_r),
        .tx_data  (tx_data_r),
        .start    (spi_start),
        .rx_data  (spi_rx_data),
        .busy     (spi_busy),
        .sclk     (sclk_w),
        .mosi     (mosi_w),
        .miso     (miso_w)
    );

    // ---- the ASIC design, instantiated unmodified ----
    chip_top u_chip (
        .clk          (clk),
        .rst_n        (rst_n),
        .sclk         (sclk_w),
        .mosi         (mosi_w),
        .miso         (miso_w),
        .cs_n         (cs_n_r),
        .busy         (chip_busy),
        .result_ready (chip_result_ready),
        .err          (chip_err)
    );

    // =========================================================================
    // Pushbuttons
    //
    // ACTIVE_HIGH is set for the ZCU106 5-way switch. If the raw bits in the
    // BTN register read as 1 when nothing is pressed, flip this to 0 and
    // rebuild -- that is the only change needed.
    // =========================================================================
    button_ctrl #(
        .CLK_HZ      (CLK_HZ),
        .DEBOUNCE_MS (10),
        .WINDOW_MS   (250),
        .ACTIVE_HIGH (1)
    ) u_btn (
        .clk       (clk),
        .rst_n     (rst_n),
        .btn_raw   (btn),
        .btn_state (btn_state),
        .evt_code  (btn_evt_code),
        .evt_valid (btn_evt_valid)
    );

    // =========================================================================
    // Board LEDs
    // =========================================================================
    status_led #(.CLK_HZ(CLK_HZ)) u_led (
        .clk      (clk),
        .rst_n    (rst_n),
        .status   (led_status_r),
        .led_pass (led_pass),
        .led_fail (led_fail)
    );

endmodule
