`timescale 1ns / 1ps

module iob_t2p_asym_ram 
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
         input [W_DATA_W-1:0]  w_data, //Input data to write port
         input [W_ADDR_W-1:0]  w_addr, //address for write port
	 input 		       rclk, //read clock
         input [R_ADDR_W-1:0]  r_addr, //address for read port
         input 		       r_en,
        //Outputs
         output [R_DATA_W-1:0] r_data //output port
    );
    
    generate
    	if (W_DATA_W > R_DATA_W)
    	begin
    		iob_t2p_asym_ram_w_wide_r_narrow #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W)
    		 ) two_port_ram (
    		 	.wclk(wclk),
    		 	.w_en(w_en),
    		 	.w_data(w_data),
    		 	.w_addr(w_addr),
			.rclk(rclk),
    		 	.r_addr(r_addr),
    		 	.r_en(r_en),
    		 	.r_data(r_data)
    		 );
    	end
    	else if (W_DATA_W == R_DATA_W)
	  begin
	     iob_t2p_ram #(
				.DATA_W(W_DATA_W),
				.ADDR_W(W_ADDR_W)
				) two_port_ram (
	 					.wclk(wclk),
    		 				.w_en(w_en),
    		 				.w_data(w_data),
    		 				.w_addr(w_addr),
						.rclk(rclk),
    		 				.r_addr(r_addr),
    		 				.r_en(r_en),
    		 				.r_data(r_data)
						);
	  end // if (W_DATA_W == R_DATA_W)
	else
    	begin
    		iob_t2p_asym_ram_w_narrow_r_wide #(
    			.W_DATA_W(W_DATA_W),
    		 	.W_ADDR_W(W_ADDR_W),
    		 	.R_DATA_W(R_DATA_W),
    		 	.R_ADDR_W(R_ADDR_W)
    		 ) two_port_ram (
    		 	.wclk(wclk),
    		 	.w_en(w_en),
    		 	.w_data(w_data),
    		 	.w_addr(w_addr),
			.rclk(rclk),
    		 	.r_addr(r_addr),
    		 	.r_en(r_en),
    		 	.r_data(r_data)
    		 );
    	end
    endgenerate
endmodule
    
