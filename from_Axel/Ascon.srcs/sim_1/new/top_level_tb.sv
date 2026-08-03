`timescale 1ns / 1ps

module tb_top_level;

    // -------- Signals --------
    logic clock_i;
    logic reset_i;
    logic Rx_i;
    logic Tx_o;

    // -------- DUT --------
    top_level DUT (
        .clock_i(clock_i),
        .reset_i(reset_i),
        .Rx_i(Rx_i),
        .Tx_o(Tx_o)
    );

    // -------- Clock 50 MHz --------
    always #10 clock_i = ~clock_i; // 20 ns → 50 MHz

    // -------- UART parameters --------
    parameter BAUD_RATE = 115200;
    parameter BIT_TIME = 1_000_000_000 / BAUD_RATE;

    // -------- UART TX (PC → FPGA) --------
    task uart_send_byte(input [7:0] data);
        integer i;
        begin
            // Start
            Rx_i = 0;
            #(BIT_TIME);

            // Data
            for (i = 0; i < 8; i++) begin
                Rx_i = data[i];
                #(BIT_TIME);
            end

            // Stop
            Rx_i = 1;
            #(BIT_TIME);
        end
    endtask

    // -------- Send buffer --------
    task uart_send_array(input byte data_array[], input int size);
        int i;
        begin
            for (i = 0; i < size; i++) begin
                uart_send_byte(data_array[i]);
            end
        end
    endtask

    // -------- DATA --------

    // KEY (16)
    byte key [0:15] = '{
        8'h8A, 8'h55, 8'h11, 8'h4D,
        8'h1C, 8'hB6, 8'hA9, 8'hA2,
        8'hBE, 8'h26, 8'h3D, 8'h4D,
        8'h7A, 8'hEC, 8'hAA, 8'hFF
    };

    // NONCE (16)
    byte nonce [0:15] = '{
        8'h4E, 8'hD0, 8'hEC, 8'h0B,
        8'h98, 8'hC5, 8'h29, 8'hB7,
        8'hC8, 8'hCD, 8'hDF, 8'h37,
        8'hBC, 8'hD0, 8'h28, 8'h4A
    };

    // AD (6)
    byte ad [0:7] = '{
        8'h41, 8'h20, 8'h74,8'h6F,
        8'h20, 8'h42, 8'h00,8'h00
    };

    // PLAINTEXT (181)
    byte plaintext [0:183] = '{
        8'h5A,8'h5B,8'h5B,8'h5A,8'h5A,8'h5A,8'h5A,8'h5A,
        8'h59,8'h55,8'h4E,8'h4A,8'h4C,8'h4F,8'h54,8'h55,
        8'h53,8'h51,8'h53,8'h54,8'h56,8'h57,8'h58,8'h57,
        8'h5A,8'h5A,8'h59,8'h57,8'h56,8'h59,8'h5B,8'h5A,
        8'h55,8'h54,8'h54,8'h52,8'h52,8'h50,8'h4F,8'h4F,
        8'h4C,8'h4C,8'h4D,8'h4D,8'h4A,8'h49,8'h44,8'h44,
        8'h47,8'h47,8'h46,8'h44,8'h42,8'h43,8'h41,8'h40,
        8'h3B,8'h36,8'h38,8'h3E,8'h44,8'h49,8'h49,8'h47,
        8'h47,8'h46,8'h46,8'h44,8'h43,8'h42,8'h43,8'h45,
        8'h47,8'h45,8'h44,8'h45,8'h46,8'h47,8'h4A,8'h49,
        8'h47,8'h45,8'h48,8'h4F,8'h58,8'h69,8'h7C,8'h92,
        8'hAE,8'hCE,8'hED,8'hFF,8'hFF,8'hE3,8'hB4,8'h7C,
        8'h47,8'h16,8'h00,8'h04,8'h17,8'h29,8'h36,8'h3C,
        8'h3F,8'h3E,8'h40,8'h41,8'h41,8'h41,8'h40,8'h3F,
        8'h3F,8'h40,8'h3F,8'h3E,8'h3B,8'h3A,8'h3B,8'h3E,
        8'h3D,8'h3E,8'h3C,8'h39,8'h3C,8'h41,8'h46,8'h46,
        8'h46,8'h45,8'h44,8'h47,8'h46,8'h4A,8'h4C,8'h4F,
        8'h4C,8'h50,8'h55,8'h55,8'h52,8'h4F,8'h51,8'h55,
        8'h59,8'h5C,8'h5A,8'h59,8'h5A,8'h5C,8'h5C,8'h5B,
        8'h59,8'h59,8'h57,8'h53,8'h51,8'h50,8'h4F,8'h4F,
        8'h53,8'h57,8'h5A,8'h5C,8'h5A,8'h5B,8'h5D,8'h5E,
        8'h60,8'h60,8'h61,8'h5F,8'h60,8'h5F,8'h5E,8'h5A,
        8'h58,8'h57,8'h54,8'h52,8'h52,8'h80,8'h00,8'h00
    };

    // -------- Stimulus --------
    initial begin
        clock_i = 0;
        reset_i = 0;
        Rx_i = 1;

        #100;
        reset_i = 1;

        #1000;

        // Envoi complet (comme un PC)
        uart_send_byte(8'h4B);
        uart_send_array(key, 16);
        #10000;
        uart_send_byte(8'h4E);
        uart_send_array(nonce, 16);
        #10000;
        uart_send_byte(8'h41);
        uart_send_array(ad, 8);
        #10000;
        uart_send_byte(8'h57);
        uart_send_array(plaintext, 184);

        // Attente traitement
        #5_000_000;

        $stop;
    end

endmodule