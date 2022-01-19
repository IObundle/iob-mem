`timescale 1ns/1ps

module bin_counter #(parameter   COUNTER_WIDTH = 4)
   (
	input 			                rst, //Count reset.
	input 			                clk,
	input 			                en, //Count enable.
	output reg [COUNTER_WIDTH-1:0] 	data_out
	);
	   
   	always @ (posedge clk or posedge rst)
		if (rst)
		    data_out <= 0;  
		else if (en)
		    data_out <= data_out + 1'b1;
   
endmodule
