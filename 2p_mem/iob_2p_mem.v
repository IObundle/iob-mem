`timescale 1ns/1ps

module iob_2p_mem
	#( 
		parameter DATA_W = 8,
		parameter ADDR_W = 6,
		parameter USE_RAM = 1
	) 
	(
	 input                   clk,

	 //write port
         input                   w_port_en,
         input                   w_en,
         input [ADDR_W-1:0]      w_addr,
         input [DATA_W-1:0]      data_in,

         //read port
         input                   r_port_en,
         input [ADDR_W-1:0]      r_addr,
         output reg [DATA_W-1:0] data_out
    );

   //memory declaration
   generate
   if(USE_RAM) begin
	reg [DATA_W-1:0]              ram [2**ADDR_W-1:0];
   //writing to the RAM
    always@(posedge clk)
	  if(w_en && w_port_en)
	    ram[w_addr] <= data_in;
   //reading from the RAM
   always@(posedge clk)
     if(r_port_en)
       data_out <= ram[r_addr];
   end
   else begin
	reg [DATA_W*(2**ADDR_W)-1:0] 	 mem ;
   //writing to the register
	always@(posedge clk)
   	  if(w_en && w_port_en)
	    mem[8*w_addr +: 8] <= data_in;
	//reading from the RAM
    always@(posedge clk)
      if(r_port_en)
        data_out <= mem[8*r_addr +: 8];
   end
   endgenerate


endmodule   
