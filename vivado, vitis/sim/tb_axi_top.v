// =============================================================================
// tb_axi_top.v
// Full PL-stack testbench.
//
// Drives crypto_axi_top through a real AXI4-Lite master model, performing the
// exact same register sequence the Vitis application performs. If this passes,
// the only things left untested on the board are the block design wiring, the
// pin constraints and the PS itself.
//
// Clock: 100 MHz (the PL clock the block design provides)
// SCLK : f_clk / 16 = 6.25 MHz with the default divider of 8
// =============================================================================
`timescale 1ns/1ps

module tb_axi_top;

    localparam CLK_PERIOD = 10;          // 100 MHz
    localparam AW = 5;
    localparam DW = 32;

    // Register offsets
    localparam REG_ID     = 5'h00;
    localparam REG_CTRL   = 5'h04;
    localparam REG_XFER   = 5'h08;
    localparam REG_STATUS = 5'h0C;
    localparam REG_LED    = 5'h10;
    localparam REG_BTN    = 5'h14;

    reg clk = 1'b0;
    reg aresetn = 1'b0;
    always #(CLK_PERIOD/2) clk = ~clk;

    // ---- AXI4-Lite master signals ----
    reg  [AW-1:0]   awaddr  = 0;
    reg             awvalid = 0;
    wire            awready;
    reg  [DW-1:0]   wdata   = 0;
    reg  [DW/8-1:0] wstrb   = 4'hF;
    reg             wvalid  = 0;
    wire            wready;
    wire [1:0]      bresp;
    wire            bvalid;
    reg             bready  = 0;
    reg  [AW-1:0]   araddr  = 0;
    reg             arvalid = 0;
    wire            arready;
    wire [DW-1:0]   rdata;
    wire [1:0]      rresp;
    wire            rvalid;
    reg             rready  = 0;

    wire [7:0] led;
    reg  [1:0] btn = 2'b00;

    crypto_axi_top #(
        .C_S_AXI_DATA_WIDTH (DW),
        .C_S_AXI_ADDR_WIDTH (AW),
        .CLK_HZ             (100_000)
    ) dut (
        .s_axi_aclk    (clk),
        .s_axi_aresetn (aresetn),
        .s_axi_awaddr  (awaddr),
        .s_axi_awprot  (3'b000),
        .s_axi_awvalid (awvalid),
        .s_axi_awready (awready),
        .s_axi_wdata   (wdata),
        .s_axi_wstrb   (wstrb),
        .s_axi_wvalid  (wvalid),
        .s_axi_wready  (wready),
        .s_axi_bresp   (bresp),
        .s_axi_bvalid  (bvalid),
        .s_axi_bready  (bready),
        .s_axi_araddr  (araddr),
        .s_axi_arprot  (3'b000),
        .s_axi_arvalid (arvalid),
        .s_axi_arready (arready),
        .s_axi_rdata   (rdata),
        .s_axi_rresp   (rresp),
        .s_axi_rvalid  (rvalid),
        .s_axi_rready  (rready),
        .btn           (btn),
        .led           (led)
    );

    integer errors  = 0;
    integer vectors = 0;

    // ---------------------------------------------------------------------
    // AXI4-Lite master tasks
    // ---------------------------------------------------------------------
    task axi_write(input [AW-1:0] addr, input [DW-1:0] data);
        begin
            @(posedge clk);
            awaddr  <= addr;  awvalid <= 1'b1;
            wdata   <= data;  wvalid  <= 1'b1;  wstrb <= 4'hF;
            bready  <= 1'b1;
            // wait for both address and data handshakes
            @(posedge clk);
            while (!(awready && wready)) @(posedge clk);
            awvalid <= 1'b0;  wvalid <= 1'b0;
            @(posedge clk);
            while (!bvalid) @(posedge clk);
            if (bresp !== 2'b00) begin
                $display("  !! write BRESP=%b at addr %02h", bresp, addr);
                errors = errors + 1;
            end
            @(posedge clk);
            bready <= 1'b0;
        end
    endtask

    reg [DW-1:0] rd_val;

    task axi_read(input [AW-1:0] addr);
        begin
            @(posedge clk);
            araddr  <= addr;  arvalid <= 1'b1;  rready <= 1'b1;
            @(posedge clk);
            while (!arready) @(posedge clk);
            arvalid <= 1'b0;
            @(posedge clk);
            while (!rvalid) @(posedge clk);
            rd_val = rdata;
            if (rresp !== 2'b00) begin
                $display("  !! read RRESP=%b at addr %02h", rresp, addr);
                errors = errors + 1;
            end
            @(posedge clk);
            rready <= 1'b0;
        end
    endtask

    // ---------------------------------------------------------------------
    // Driver-level helpers, mirroring the Vitis application
    // ---------------------------------------------------------------------
    reg [7:0] sclk_div = 8'd8;

    task cs_low;  begin axi_write(REG_CTRL, {16'd0, sclk_div, 8'h00}); end endtask
    task cs_high; begin axi_write(REG_CTRL, {16'd0, sclk_div, 8'h01}); end endtask

    reg [7:0] xfer_rx;

    task spi_byte(input [7:0] tx);
        integer guard;
        begin
            axi_write(REG_XFER, {24'd0, tx});
            guard = 0;
            axi_read(REG_XFER);
            while (rd_val[8] === 1'b1 && guard < 5000) begin
                axi_read(REG_XFER);
                guard = guard + 1;
            end
            if (guard >= 5000) begin
                $display("  !! spi_byte timeout");
                errors = errors + 1;
            end
            xfer_rx = rd_val[7:0];
        end
    endtask

    task wait_result_ready;
        integer guard;
        begin
            guard = 0;
            axi_read(REG_STATUS);
            while (rd_val[2] !== 1'b1 && guard < 5000) begin
                axi_read(REG_STATUS);
                guard = guard + 1;
            end
            if (guard >= 5000) begin
                $display("  !! result_ready timeout (STATUS=%08h)", rd_val);
                errors = errors + 1;
            end
        end
    endtask

    reg [255:0] result_buf;

    task read_result;
        integer i;
        begin
            result_buf = 256'd0;
            cs_low;
            for (i = 0; i < 32; i = i + 1) begin
                spi_byte(8'h00);
                result_buf = {result_buf[247:0], xfer_rx};
            end
            cs_high;
        end
    endtask

    // ---------------------------------------------------------------------
    // Test operations
    // ---------------------------------------------------------------------
    task do_sha(input [255:0] msg, input [7:0] len, input [255:0] expect);
        integer i;
        begin
            vectors = vectors + 1;
            cs_low;
            spi_byte(8'h01);
            spi_byte(len);
            for (i = 0; i < len; i = i + 1)
                spi_byte(msg[255 - i*8 -: 8]);
            cs_high;
            wait_result_ready;
            read_result;
            if (result_buf === expect)
                $display("  PASS sha   len=%0d", len);
            else begin
                $display("  FAIL sha   len=%0d", len);
                $display("       got %h", result_buf);
                $display("       exp %h", expect);
                errors = errors + 1;
            end
        end
    endtask

    task do_ascon(input [127:0] k, input [127:0] n,
                  input [255:0] pt, input [7:0] len,
                  input [255:0] expect);
        integer i;
        begin
            vectors = vectors + 1;
            cs_low;
            spi_byte(8'h02);
            spi_byte(len);
            for (i = 0; i < 16; i = i + 1) spi_byte(k[127 - i*8 -: 8]);
            for (i = 0; i < 16; i = i + 1) spi_byte(n[127 - i*8 -: 8]);
            for (i = 0; i < len; i = i + 1) spi_byte(pt[255 - i*8 -: 8]);
            cs_high;
            wait_result_ready;
            read_result;
            if (result_buf === expect)
                $display("  PASS ascon len=%0d", len);
            else begin
                $display("  FAIL ascon len=%0d", len);
                $display("       got %h", result_buf);
                $display("       exp %h", expect);
                errors = errors + 1;
            end
        end
    endtask

    // ---------------------------------------------------------------------
    // Press buttons and read the event back the way software will
    // ---------------------------------------------------------------------
    task test_button(input [1:0] press, input [1:0] expect_code,
                     input [8*24:1] name);
        integer guard;
        begin
            vectors = vectors + 1;
            btn = press;
            repeat (40000) @(posedge clk);        // hold past the window
            btn = 2'b00;
            repeat (2000) @(posedge clk);

            guard = 0;
            axi_read(REG_BTN);
            while (rd_val[4] !== 1'b1 && guard < 200) begin
                axi_read(REG_BTN); guard = guard + 1;
            end

            if (rd_val[4] === 1'b1 && rd_val[3:2] === expect_code)
                $display("  PASS button %0s", name);
            else begin
                $display("  FAIL button %0s: BTN=%08h", name, rd_val);
                errors = errors + 1;
            end

            axi_write(REG_BTN, 32'h10);           // acknowledge
            axi_read(REG_BTN);
            if (rd_val[4] !== 1'b0) begin
                $display("  FAIL button ack did not clear (BTN=%08h)", rd_val);
                errors = errors + 1;
            end
            repeat (2000) @(posedge clk);
        end
    endtask

    // ---------------------------------------------------------------------
    // Main sequence
    // ---------------------------------------------------------------------
    initial begin
        repeat (20) @(posedge clk);
        aresetn = 1'b1;
        repeat (20) @(posedge clk);

        $display("=== crypto_axi_top full PL stack test ===");

        // -- infrastructure check --
        axi_read(REG_ID);
        if (rd_val === 32'h5AA5C0DE)
            $display("  PASS ID register = %08h", rd_val);
        else begin
            $display("  FAIL ID register = %08h (expected 5AA5C0DE)", rd_val);
            errors = errors + 1;
        end
        vectors = vectors + 1;

        // -- register readback --
        axi_write(REG_LED, 32'h3);
        axi_read(REG_LED);
        if (rd_val[1:0] === 2'b11) $display("  PASS LED register readback");
        else begin
            $display("  FAIL LED register readback = %08h", rd_val);
            errors = errors + 1;
        end
        vectors = vectors + 1;

        // -- LED bar outputs --
        // Pass lights all eight, fail darkens all eight. Both are static
        // states, so unlike idle and running they can be checked directly
        // without waiting on the blink counter; status_led registers the bar
        // one clock after the status write, so a few edges is plenty.
        axi_write(REG_LED, 32'h1);
        repeat (4) @(posedge clk);
        if (led === 8'hFF) $display("  PASS LED bar all on for pass");
        else begin
            $display("  FAIL LED bar = %02h for pass (expected ff)", led);
            errors = errors + 1;
        end
        vectors = vectors + 1;

        axi_write(REG_LED, 32'h2);
        repeat (4) @(posedge clk);
        if (led === 8'h00) $display("  PASS LED bar all off for fail");
        else begin
            $display("  FAIL LED bar = %02h for fail (expected 00)", led);
            errors = errors + 1;
        end
        vectors = vectors + 1;

        cs_high;
        axi_read(REG_CTRL);
        if (rd_val[15:8] === 8'd8 && rd_val[0] === 1'b1)
            $display("  PASS CTRL register readback");
        else begin
            $display("  FAIL CTRL register readback = %08h", rd_val);
            errors = errors + 1;
        end
        vectors = vectors + 1;

        // -- pushbutton event path --
        // CLK_HZ is scaled to 100 kHz here, so 1 ms = 100 cycles:
        // debounce = 1000 cycles, collection window = 25000 cycles.
        test_button(2'b01, 2'b01, "W only -> Ascon");
        test_button(2'b10, 2'b10, "E only -> SHA-256");
        test_button(2'b11, 2'b11, "W+E    -> both");

        // -- crypto vectors through the whole path --
        `include "axi_vectors.vh"

        axi_write(REG_LED, (errors == 0) ? 32'h1 : 32'h2);

        $display("=== vectors=%0d errors=%0d ===", vectors, errors);
        if (errors == 0) $display("RESULT: ALL PASS");
        else             $display("RESULT: FAILURES PRESENT");
        $finish;
    end

    initial begin
        #2_000_000_000;
        $display("GLOBAL TIMEOUT");
        $finish;
    end

endmodule
