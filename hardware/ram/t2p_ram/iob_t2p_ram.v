`timescale 1ns/1ps

module iob_t2p_ram
  #( 
     parameter FILE="none",
     parameter DATA_W = 0,
     parameter ADDR_W = 0
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

   //this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = FILE;

   // Declare the RAM
   reg [DATA_W-1:0]         ram [2**ADDR_W-1:0];

   // Initialize the RAM
   initial
     if(mem_init_file_int != "none")
       $readmemh(mem_init_file_int, ram, 0, 2**ADDR_W - 1);

   //write
   always@(posedge wclk)
     if(w_en)
       ram[w_addr] <= w_data;

   //read mode depends on mem implementation, as ram or reg
   always@(posedge rclk)  begin
      if(r_en)
        r_data <= ram[r_addr];
   end

endmodule   
