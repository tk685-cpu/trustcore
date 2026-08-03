`timescale 1ns / 1ps

module reg_shift128_tb;

    // Signaux du testbench
    logic clock_s;
    logic reset_s;
    logic [3:0] data_s;
    logic ena_s;
    logic [127:0] data_out_s;

    // Instanciation du DUT (Device Under Test)
    reg_shift128 dut (
        .clock_i(clock_s),
        .reset_i(reset_s),
        .data_i(data_s),
        .ena_i(ena_s),
        .data_o(data_out_s)
    );

    // Génération de l'horloge (période 10 ns)
    initial begin
        clock_s = 0;
        forever #5 clock_s = ~clock_s;
    end

    // Stimulus
    initial begin
        
        // Initialisation
        reset_s = 0;
        ena_s   = 0;
        data_s  = 4'b0000;

        #25;

        // Fin du reset
        reset_s = 1;
        
        // Activation du shift
        ena_s = 1;
        
        data_s = 4'hA; #10;
        data_s = 4'hB; #10;
        data_s = 4'hC; #10;
        data_s = 4'hD; #10;
        data_s = 4'h1; #10;
        data_s = 4'h2; #10;
        data_s = 4'h3; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;
        data_s = 4'h4; #10;

        // Désactivation
        ena_s = 0;
        #20;

        // Fin simulation
        $stop;
    end

    // Monitoring
    initial begin
        $monitor("time=%0t reset=%b ena=%b data_i=%h data_o=%h",
                  $time, reset_s, ena_s, data_s, data_out_s);
    end

endmodule