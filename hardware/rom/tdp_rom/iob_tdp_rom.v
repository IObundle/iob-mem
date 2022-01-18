`timescale 1 ns / 1 ps

module iob_tdp_rom 
  #(
    parameter FILE="none",
    parameter DATA_W=32,
    parameter ADDR_W=11
    )
   (
    input                     clk_a,
    input [(ADDR_W-1):0]      addr_a,
    input                     r_en_a,
    output reg [(DATA_W-1):0] r_data_a,

    input                     clk_b,
    input [(ADDR_W-1):0]      addr_b,
    input                     r_en_b,
    output reg [(DATA_W-1):0] r_data_b
    );

   //this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = FILE;

   
   // Declare the ROM
   reg [DATA_W-1:0] 			       rom[2**ADDR_W-1:0];

   // Initialize the ROM
   initial 
     if(mem_init_file_int != "none")
       $readmemh(mem_init_file_int, rom, 0, 2**ADDR_W - 1);

   always @ (posedge clk_a) // Port A
     if (r_en_a)
       r_data_a <= rom[addr_a];

   always @ (posedge clk_b) // Port B
     if (r_en_b)
       r_data_b <= rom[addr_b];

 endmodule
