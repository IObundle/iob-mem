`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}


/* WARNING: This memory assumes that the write port data width is bigger than the
read port data width and that they are multiples of eachother
*/
module iob_sync_assim_fifo
	#(
		parameter W_DATA_W = 8,
		parameter W_ADDR_W = 7,
		parameter R_ADDR_W = 6,
		parameter R_DATA_W = 16
	)
	(
	input                       rst,
	input                       clk,
	
	output reg [31:0]   		fifo_ocupancy,
	

	//read port
	output [R_DATA_W-1:0]		data_out, 
	output		                empty,
	input                       read_en,

	//write port	 
	input [W_DATA_W-1:0]      	data_in, 
	output		                full,
	input                       write_en
	);

	//local variables
	localparam maxADDR_W = `max(W_ADDR_W, R_ADDR_W);
	localparam maxDATA_W = `max(W_DATA_W, R_DATA_W);
	localparam minDATA_W = `min(W_DATA_W, R_DATA_W);
	localparam RATIO = maxDATA_W / minDATA_W;
	localparam FIFO_DEPTH = (2**maxADDR_W);
	

	//WRITE DOMAIN 
	wire [W_ADDR_W-1:0]   		wptr;
	wire                        write_en_int;
	
	//READ DOMAIN    
	wire [R_ADDR_W-1:0]    		rptr;
	wire                        read_en_int;

	//FIFO ocupancy counter
	generate
		if(W_DATA_W > R_DATA_W) begin
			always @ (posedge clk or posedge rst)
				if (rst)
					fifo_ocupancy <= 0;
				else if (write_en_int & !read_en_int)
					fifo_ocupancy <= fifo_ocupancy+RATIO;
				else if (read_en_int & !write_en_int)
					fifo_ocupancy <= fifo_ocupancy-1;
				else if (read_en_int & write_en_int)
					fifo_ocupancy <= fifo_ocupancy+RATIO-1;
		end
		else begin
			always @ (posedge clk or posedge rst)
			if (rst)
				fifo_ocupancy <= 0;
			else if (write_en_int & !read_en_int)
				fifo_ocupancy <= fifo_ocupancy+1;
			else if (read_en_int & !write_en_int)
				fifo_ocupancy <= fifo_ocupancy-RATIO;
			else if (read_en_int & write_en_int)
				fifo_ocupancy <= fifo_ocupancy-RATIO+1;
		end
	endgenerate
	
	
	//WRITE DOMAIN LOGIC
	//effective write enable
	assign write_en_int = write_en & ~full;
	assign full = (fifo_ocupancy == FIFO_DEPTH);
    
	bin_counter #(W_ADDR_W) wptr_counter (
	   	.clk(clk),
	   	.rst(rst), 
	   	.en(write_en_int),
	   	.data_out(wptr)
	);

	//READ DOMAIN LOGIC
	//effective read enable
	assign read_en_int  = read_en & ~empty;
	assign empty = (fifo_ocupancy == 0);
	
	bin_counter #(R_ADDR_W) rptr_counter (
	   	.clk(clk),
	   	.rst(rst), 
		.en(read_en_int),
	   	.data_out(rptr)
	);
	
	
	//FIFO memory
	iob_2p_assim_mem #(
		.W_DATA_W(W_DATA_W), 
		.W_ADDR_W(W_ADDR_W),
		.R_ADDR_W(R_ADDR_W),
		.R_DATA_W(R_DATA_W)
	) fifo_mem (
		.clk(clk),
		.w_en(write_en_int),
		.data_in(data_in),
		.w_addr(wptr),
		.r_addr(rptr),
		.r_en(read_en_int),
		.data_out(data_out)
	);

endmodule
   

