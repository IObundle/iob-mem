`timescale 1ns / 1ps

module iob_2p_asym_ram
	#(
		parameter W_DATA_W = 16,
		parameter W_ADDR_W = 6,
		parameter R_DATA_W = 8,
		parameter R_ADDR_W = 7,
    parameter USE_RAM = 1
	)
	(
		//Inputs
		input 				clk,
    input 				w_en,    //write enable
    input [W_DATA_W-1:0] 	w_data, //Input data to write port
    input [W_ADDR_W-1:0] 	w_addr,  //address for write port
    input [R_ADDR_W-1:0] 	r_addr,  //address for read port
    input				  r_en,
    //Outputs
    output [R_DATA_W-1:0] r_data //output port
    );

    generate
    	if (W_DATA_W > R_DATA_W)
    	begin
    		iob_2p_asym_ram_w_big #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W),
                .USE_RAM(USE_RAM)
    		 ) two_port_ram (
    		 	.clk(clk),
    		 	.w_en(w_en),
    		 	.w_data(w_data),
    		 	.w_addr(w_addr),
    		 	.r_addr(r_addr),
    		 	.r_en(r_en),
    		 	.r_data(r_data)
    		 );
    	end
    	else
    	begin
    		iob_2p_asym_ram_r_big #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W)
    		 ) two_port_ram (
    		 	.clk(clk),
    		 	.w_en(w_en),
    		 	.w_data(w_data),
    		 	.w_addr(w_addr),
    		 	.r_addr(r_addr),
    		 	.r_en(r_en),
    		 	.r_data(r_data)
    		 );
    	end
    endgenerate
endmodule