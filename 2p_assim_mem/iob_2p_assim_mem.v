module iob_2p_assim_mem 
	#(
		parameter W_DATA_W = 16,
		parameter W_ADDR_W = 6,
		parameter R_DATA_W = 8,
		parameter R_ADDR_W = 7
	)
	(
		//Inputs
		input 				clk,
        input 				w_en,    //write enable
        input [W_DATA_W-1:0] 	data_in, //Input data to write port
        input [W_ADDR_W-1:0] 	w_addr,  //address for write port
        input [R_ADDR_W-1:0] 	r_addr,  //address for read port
        input 				w_port_en,
        input				r_port_en,
        //Outputs
        output [R_DATA_W-1:0] data_out //output port
    );
    
    generate
    	if (W_DATA_W > R_DATA_W)
    	begin
    		iob_2p_assim_mem_w_big #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W)
    		 ) two_port_mem (
    		 	.clk(clk),
    		 	.w_en(w_en),
    		 	.data_in(data_in),
    		 	.w_addr(w_addr),
    		 	.r_addr(r_addr),
    		 	.w_port_en(w_port_en),
    		 	.r_port_en(r_port_en),
    		 	.data_out(data_out)
    		 );
    	end
    	else
    	begin
    		iob_2p_assim_mem_r_big #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W)
    		 ) two_port_mem (
    		 	.clk(clk),
    		 	.w_en(w_en),
    		 	.data_in(data_in),
    		 	.w_addr(w_addr),
    		 	.r_addr(r_addr),
    		 	.w_port_en(w_port_en),
    		 	.r_port_en(r_port_en),
    		 	.data_out(data_out)
    		 );
    	end
    endgenerate
endmodule
    
