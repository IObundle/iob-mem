`timescale 1ns/1ps

module iob_t2p_ram
  #( 
     parameter DATA_W = 8,
     parameter ADDR_W = 6,
     parameter USE_RAM = 1
     ) 
   (
    // Write port
    input                   wclk,
    input                   w_en,
    input [ADDR_W-1:0]      w_addr,
    input [DATA_W-1:0]      w_data,

    // Read port
    input                   rclk,
    input                   r_en,
    input [ADDR_W-1:0]      r_addr,
    output reg [DATA_W-1:0] r_data
    );

   //memory declaration
   reg [DATA_W-1:0]         mem [2**ADDR_W-1:0];

   //write
   always@(posedge wclk)
     if(w_en)
       mem[w_addr] <= w_data;

   //read mode depends on mem implementation, as ram or reg
   generate
      if(USE_RAM)
        always@(posedge rclk)  begin
           if(r_en)
             r_data <= mem[r_addr];
        end
      else //use reg file
        always@* r_data = mem[r_addr];
   endgenerate

endmodule   
