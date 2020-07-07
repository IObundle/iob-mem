`timescale 1ns / 1ps

module sp_rom #(
             parameter DATA_W = 8,
             parameter ADDR_W = 10,
             parameter FILE = "rom.dat"
	     )
   (
    input                    clk,
    input                    r_en,
    input [ADDR_W-1:0]       addr,
    output reg [DATA_W-1:0] rdata
    );
   
   // this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = FILE;

   // Declare the ROM
   reg [DATA_W-1:0]     rom[2**ADDR_W-1:0];

   // Initialize the ROM
   initial 
     $readmemh(mem_init_file_int, rom, 0, 2**ADDR_W-1);

   // Operate the ROM
   always @(posedge clk)
     if(r_en)
       rdata <= rom[addr];
   
endmodule
