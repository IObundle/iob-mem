`timescale 1ns/1ps

module iob_2p_assim_mem_tiled
    #(
        parameter DATA_W_A  = 32,           // write data width
        parameter DATA_W_B  = 16,           // read data width
        parameter WORDS     = 8192,         // number of words
        parameter ADDR_W_A  = $clog2(WORDS*DATA_W_A),
        parameter ADDR_W_B  = $clog2(WORDS*DATA_W_B)
    )
    (
        // Inputs
        input                   clk,
        input                   w_en,       // write enable
        input                   r_en,       // read enable
        input  [DATA_W_A-1:0]   data_in,    // input data to write port
        input  [ADDR_W_A-1:0]   w_addr,     // address for write port
        input  [ADDR_W_B-1:0]   r_addr,     // address for read port

        // Outputs
        output [DATA_W_B-1:0]   data_out    //output port
    );

        // Number of BRAMs to generate, each containing 2048 words maximum
        // Each word has (DATA_W/8) bytes
        localparam K = $ceil(WORDS*(DATA_W_A/8)/2048.0);
        

    generate
        genvar i;

        // Generate K BRAMs
        for(i = 0; i < K; i = i + 1) begin

            iob_2p_assim_mem #(
                .W_DATA_W(DATA_W_A),
                .W_ADDR_W(ADDR_W_A),
                .R_DATA_W(DATA_W_B),
                .R_ADDR_W(ADDR_W_B)
            ) bram (
                .clk(clk),
                .w_en(w_en),
                .r_en(r_en),
                .data_in(data_in),
                .w_addr(w_addr),
                .r_addr(r_addr),
                .data_out(data_out)
            );
        end
        
    endgenerate
endmodule
