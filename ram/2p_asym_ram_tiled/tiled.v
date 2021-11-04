`timescale 1ns/1ps

module iob_2p_assim_mem_tiled
    #(
        parameter DATA_W_A  = 32,                       // port A data width
        parameter DATA_W_B  = 16,                       // port B data width
        parameter N_WORDS     = 8192,                     // number of words (each word has 'DATA_W/8' bytes)
        parameter ADDR_W_A  = $clog2(N_WORDS*DATA_W_A/8), // port A address width
        parameter ADDR_W_B  = $clog2(N_WORDS*DATA_W_B/8),  // port B address width
        parameter TILE_ADDR_W = 11,                     // log2 of block size
        parameter USE_RAM = 0
    )
    (
        // Inputs
        input                   clk,
        input                   w_en,
        input                   r_en,
        input  [DATA_W_A-1:0]   data_in,    // input data to write port
        input  [ADDR_W_A-1:0]   w_addr,       // address for write port
        input  [ADDR_W_B-1:0]   r_addr,       // address for read port

        // Outputs
        output reg [DATA_W_B-1:0] data_out  //output port
    );

    // Number of BRAMs to generate, each containing 2**TILE_ADDR_W bytes
    localparam K = $ceil(2**(ADDR_W_A-TILE_ADDR_W));

    // Address decoder: enables write on selected BRAM
    wire [K-1:0] addr_en;   // address decoder output
    decN #(
        .N_OUTPUTS(K)
    ) addr_dec (
        .dec_in(w_addr[ADDR_W_A-1:ADDR_W_A-$clog2(K)]), // only the first clog2(K) MSBs select the BRAM
        .dec_out(addr_en)
    );

    // Generate K BRAMs
    genvar i;
    generate
        // Vector containing all BRAM outputs
        wire [DATA_W_B-1:0] data_out_vec [K-1:0];
        for(i = 0; i < K; i = i + 1) begin
            iob_2p_assim_mem #(
                .W_DATA_W(DATA_W_A),
                .W_ADDR_W(ADDR_W_A - $clog2(K)),
                .R_DATA_W(DATA_W_B),
                .R_ADDR_W(ADDR_W_B - $clog2(K)),
                .USE_RAM(USE_RAM)
            ) bram (
                .clk(clk),
                .w_en(w_en & addr_en[i]),
                .r_en(r_en & addr_en[i]),
                .data_in(data_in),
                .w_addr(w_addr[ADDR_W_A-$clog2(K)-1:0]),
                .r_addr(r_addr[ADDR_W_B-$clog2(K)-1:0]),
                .data_out(data_out_vec[i])
            );
        end
    endgenerate

    // bram mux: outputs selected BRAM
    muxN #(
        .N_INPUTS(K),
        .INPUT_W(DATA_W_B)
    ) bram_out_sel (
        .data_in(data_out_vec),
        .sel(r_addr[ADDR_W_B-1:ADDR_W_B-$clog2(K)]),
        .data_out(data_out)
    );
endmodule

// decoder with parameterizable output
module decN
    #(
        parameter N_OUTPUTS = 16
    )
    (
        input [$clog2(N_OUTPUTS)-1:0] dec_in,
        output reg [N_OUTPUTS-1:0] dec_out
    );

    always @* begin
        dec_out  = 0;
        dec_out[dec_in] = 1'b1;
    end
endmodule

// multiplexer with parameterizable input
module muxN
    #(
        parameter N_INPUTS = 4,    // number of inputs
        parameter INPUT_W = 8,    // input bit width
        parameter S = $clog2(N_INPUTS),    // number of select lines
        parameter W = N_INPUTS * INPUT_W // total data width
    )
    (
        // Inputs
        input   [INPUT_W-1:0]   data_in [N_INPUTS-1:0],  // input port
        input   [S-1:0]   sel,      // selection port

        // Outputs
        output reg [INPUT_W-1:0]   data_out  // output port
    );
 
    always @* begin
        data_out = data_in[sel];
    end
endmodule