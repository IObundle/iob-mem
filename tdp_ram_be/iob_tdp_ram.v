`timescale 1 ns / 1 ps

module iob_tdp_ram 
  #(
    parameter MEM_INIT_FILE="none",
    parameter DATA_W=32,
    parameter ADDR_W=11
    )
   (
    input                     clk,

    input [(DATA_W-1):0]      data_a,
    input [(ADDR_W-1):0]      addr_a,
    input                     en_a,
    input                     we_a,
    output reg [(DATA_W-1):0] q_a,
    
    input [(DATA_W-1):0]      data_b,
    input [(ADDR_W-1):0]      addr_b,
    input                     en_b,
    input                     we_b,
    output reg [(DATA_W-1):0] q_b
    );

   //this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = MEM_INIT_FILE;

   
   // Declare the RAM
   reg [DATA_W-1:0] 			       ram[2**ADDR_W-1:0];

   // Initialize the RAM
   initial 
     if(mem_init_file_int != "none")
       $readmemh(MEM_INIT_FILE, ram, 0, 2**ADDR_W - 1);

   always @ (posedge clk) // Port A
     if (en_a)
       if (we_a)
	 ram[addr_a] <= data_a;
       else
	 q_a <= ram[addr_a];

   always @ (posedge clk) // Port B
     if (en_b)
       if (we_b)
	 ram[addr_b] <= data_b;
       else
	 q_b <= ram[addr_b];

 endmodule
