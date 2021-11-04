`timescale 1ns / 1ps

module iob_2p_assim_async_mem 
	#(
		parameter W_DATA_W = 16,
		parameter W_ADDR_W = 6,
		parameter R_DATA_W = 8,
		parameter R_ADDR_W = 7
	)
	(
		//Inputs
	 input 		       wclk, //write clock
         input 		       w_en, //write enable
         input [W_DATA_W-1:0]  data_in, //Input data to write port
         input [W_ADDR_W-1:0]  w_addr, //address for write port
	 input 		       rclk, //read clock
         input [R_ADDR_W-1:0]  r_addr, //address for read port
         input 		       r_en,
        //Outputs
         output [R_DATA_W-1:0] data_out //output port
    );
    
    generate
    	if (W_DATA_W > R_DATA_W)
    	begin
    		iob_2p_assim_async_mem_w_big #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W)
    		 ) two_port_mem (
    		 	.wclk(wclk),
    		 	.w_en(w_en),
    		 	.data_in(data_in),
    		 	.w_addr(w_addr),
			.rclk(rclk),
    		 	.r_addr(r_addr),
    		 	.r_en(r_en),
    		 	.data_out(data_out)
    		 );
    	end
    	else if (W_DATA_W == R_DATA_W)
	  begin
	     iob_2p_async_mem #(
				.DATA_W(W_DATA_W),
				.ADDR_W(W_ADDR_W)
				) two_port_mem (
	 					.wclk(wclk),
    		 				.w_en(w_en),
    		 				.data_in(data_in),
    		 				.w_addr(w_addr),
						.rclk(rclk),
    		 				.r_addr(r_addr),
    		 				.r_en(r_en),
    		 				.data_out(data_out)
						);
	  end // if (W_DATA_W == R_DATA_W)
	else
    	begin
    		iob_2p_assim_async_mem_r_big #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W)
    		 ) two_port_mem (
    		 	.wclk(wclk),
    		 	.w_en(w_en),
    		 	.data_in(data_in),
    		 	.w_addr(w_addr),
			.rclk(rclk),
    		 	.r_addr(r_addr),
    		 	.r_en(r_en),
    		 	.data_out(data_out)
    		 );
    	end
    endgenerate
endmodule
    
