// Single-Port BRAM with Byte-wide Write Enable
// Read-First mode 

`timescale 1 ns / 1 ps

module iob_sp_ram_be 
  #(
    parameter FILE="none",
    parameter NUM_COL = 4,
    parameter COL_WIDTH = 8,
    parameter ADDR_WIDTH = 10,  
    //Addr Width in bits : 2*ADDR_WIDTH = RAM Depth
    parameter DATA_WIDTH = NUM_COL*COL_WIDTH  //Data Width in bits
    ) 
   ( 
     input                        clk, 
     input                        en, 
     input [NUM_COL-1:0]          we, 
     input [ADDR_WIDTH-1:0]       addr, 
     input [DATA_WIDTH-1:0]       din, 
     output reg [DATA_WIDTH-1:0]  dout
     ); 

   //this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = FILE;

   // Core Memory 
   reg [DATA_WIDTH-1:0]           ram_block[(2**ADDR_WIDTH)-1:0]; 

   // Initialize the RAM
   initial 
     if(mem_init_file_int != "none")
       $readmemh(mem_init_file_int, ram_block, 0, 2**ADDR_WIDTH - 1);

   
   //Operation 
   integer                        i;     
   always @ (posedge clk) begin 
      if(en) begin 
         for(i=0;i<NUM_COL;i=i+1) begin 
            if(we[i]) begin 
               ram_block[addr][i*COL_WIDTH +: COL_WIDTH] <= din[i*COL_WIDTH +: COL_WIDTH]; 
            end 
         end dout <= ram_block[addr]; //Send Feedback
      end    
   end
   
endmodule 
