`timescale 1 ns / 1 ps

module iob_tdp_rom 
  #(
    parameter MEM_INIT_FILE="none",
    parameter DATA_W=32,
    parameter ADDR_W=11
    )
   (
    input                     clk,

    input [(ADDR_W-1):0]      addr_a,
    input                     r_en_a,
    output reg [(DATA_W-1):0] q_a,
    
    input [(ADDR_W-1):0]      addr_b,
    input                     r_en_b,
    output reg [(DATA_W-1):0] q_b
    );

   //this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = MEM_INIT_FILE;

   
   // Declare the ROM
   reg [DATA_W-1:0] 			       rom[2**ADDR_W-1:0];

   // Initialize the ROM
   initial 
     if(mem_init_file_int != "none")
       $readmemh(MEM_INIT_FILE, rom, 0, 2**ADDR_W - 1);

   always @ (posedge clk) // Port A
     if (r_en_a)
       q_a <= rom[addr_a];

   always @ (posedge clk) // Port B
     if (r_en_b)
       q_b <= rom[addr_b];

 endmodule
