`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}

/*WARNING: This memory assumes that the read port data width is bigger than the
write port data width and that they are multiples of eachother
*/
module iob_2p_assim_mem_r_big
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
        input				r_en,
        //Outputs
        output reg [R_DATA_W-1:0] data_out //output port
    );
	//local variables
	localparam maxADDR_W = `max(W_ADDR_W, R_ADDR_W);
	localparam maxDATA_W = `max(W_DATA_W, R_DATA_W);
	localparam minDATA_W = `min(W_DATA_W, R_DATA_W);
	localparam RATIO = maxDATA_W / minDATA_W;
	localparam log2RATIO = $clog2(RATIO);
	
	//memory declaration
	reg [minDATA_W-1:0] ram [2**maxADDR_W-1:0];
	
	integer i;
	reg [log2RATIO-1:0] lsbaddr;
	
	//writing to the RAM
	always@(posedge clk)
		if (w_en)
			ram[w_addr] <= data_in;
	
	//reading from the RAM
	always@(posedge clk) begin
		if (r_en) begin
			for (i = 0; i < RATIO; i = i+1) begin
				lsbaddr = i;
				data_out[(i+1)*minDATA_W-1 -: minDATA_W] <= ram[{r_addr, lsbaddr}];
			end
		end
	end

endmodule   
