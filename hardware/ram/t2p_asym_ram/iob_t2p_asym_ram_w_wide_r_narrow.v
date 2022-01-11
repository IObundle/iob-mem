`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}

/*WARNING: This memory assumes that the write port data width is bigger than the
 read port data width and that they are multiples of eachother
 */
module iob_t2p_asym_ram_w_wide_r_narrow
  #( 
     parameter W_DATA_W = 16,
     parameter W_ADDR_W = 6,
     parameter R_DATA_W = 8,
     parameter R_ADDR_W = 7,
     parameter USE_RAM = 1
     ) 
   (
    //Inputs
    input 		      wclk, //write clock
    input 		      w_en, //write enable
    input [W_DATA_W-1:0]      w_data, //Input data to write port
    input [W_ADDR_W-1:0]      w_addr, //address for write port
    input 		      rclk, //read clock
    input [R_ADDR_W-1:0]      r_addr, //address for read port
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
   //reg [log2RATIO-1:0] 	      lsbaddr;
   
   //reading from the RAM
   generate
      if(USE_RAM)
        always@(posedge rclk)  begin
`ifndef IS_CYCLONEV
           if(r_en)
`endif
             r_data <= ram[r_addr];
        end
      else //use reg file
        always@* r_data = ram[r_addr];
   endgenerate
   
   //writing to the RAM
   always@(posedge wclk) begin
      for (i = 0; i < RATIO; i = i+1) begin
	 //lsbaddr = i[log2RATIO-1:0];
	 if(w_en)    //check if write enable is ON
	   ram[{w_addr, i[log2RATIO-1:0]}] <= w_data[(i+1)*minDATA_W-1 -: minDATA_W];
      end
   end
   
endmodule   
