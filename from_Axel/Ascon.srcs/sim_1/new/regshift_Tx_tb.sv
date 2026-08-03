`timescale 1ns / 1ps

module regshift_Tx_tb;

  // DUT signals
  logic clock_i;
  logic reset_i;
  logic [63:0] data_i;
  logic ena_i;
  logic wea_i;
  logic [7:0] data_o;

  // Instantiate DUT
  regshift_Tx dut (
    .clock_i(clock_i),
    .reset_i(reset_i),
    .data_i(data_i),
    .ena_i(ena_i),
    .wea_i(wea_i),
    .data_o(data_o)
  );

  // Clock generation (10 ns period)
  always #5 clock_i = ~clock_i;

  // Stimulus
  initial begin
    // Init
    clock_i = 0;
    reset_i = 0;
    ena_i   = 0;
    wea_i   = 0;

    $display("=== START TEST ===");

    // Reset
    #10;
    reset_i = 1;
    #10;
    // ----------------------------
    // Test 1 : Write data
    // ----------------------------
    $display("Test 1: Write data");
    data_i = 64'h1122334455667788;
    ena_i  = 1;
    wea_i  = 1;
    #10;

    wea_i = 0; // disable write
    #10;

    // ----------------------------
    // Test 2 : Shift operations
    // ----------------------------
    $display("Test 2: Shift");
    repeat (10) begin
      ena_i = 1;
      #10;
      $display("Shifted output = %h", data_o);
    end

    // ----------------------------
    // Test 3 : Hold (ena = 0)
    // ----------------------------
    $display("Test 3: Hold");
    ena_i = 0;
    #30;
    $display("Hold output = %h", data_o);

    // ----------------------------
    // Test 4 : New write
    // ----------------------------
    $display("Test 4: New write");
    data_i = 64'hAABBCCDDEEFF0011;
    wea_i  = 1;
    ena_i  = 1;
    #10;

    wea_i = 0;
    ena_i = 1;

    repeat (8) begin
      #10;
      $display("Shifted output = %h", data_o);
    end

    // ----------------------------
    // End simulation
    // ----------------------------
    $display("=== END TEST ===");
    $stop;
  end

endmodule