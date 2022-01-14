`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}

/*
 In this memory, the write port width is greater and multiple of the 
 read port width
 */

module iob_t2p_asym_ram_w_narrow_r_wide
  #( 
     parameter W_DATA_W = 0,
     parameter W_ADDR_W = 0,
     parameter R_DATA_W = 0,
     parameter R_ADDR_W = 0
     ) 
   (
    //Inputs
    input 		      wclk,   //write clock
    input 		      w_en,   //write enable
    input [W_DATA_W-1:0]      w_data, //write port
    input [W_ADDR_W-1:0]      w_addr, //write port address
    input 		      rclk,   //read clock
    input [R_ADDR_W-1:0]      r_addr, //read port address
    input 		      r_en,
    //Outputs
    output reg [R_DATA_W-1:0] r_data //output port
    );
   
   //local variables
   localparam maxADDR_W = `max(W_ADDR_W, R_ADDR_W);
   localparam maxDATA_W = `max(W_DATA_W, R_DATA_W);
   localparam minDATA_W = `min(W_DATA_W, R_DATA_W);
   localparam RATIO = maxDATA_W / minDATA_W;
   localparam log2RATIO = $clog2(RATIO);
   
   //memory declaration
   reg [minDATA_W-1:0] 	      ram [2**maxADDR_W-1:0];
   
   integer 		      i;
   
   //read port
   always@(posedge rclk)
     if (r_en)
       for (i = 0; i < RATIO; i = i+1)
	 r_data[(i+1)*minDATA_W-1 -: minDATA_W] <= ram[{r_addr, i[log2RATIO-1:0]}];

   //write port
   always@(posedge wclk)
     if (w_en)
       ram[w_addr] <= w_data;
   
endmodule   
