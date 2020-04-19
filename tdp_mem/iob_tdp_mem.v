`timescale 1 ns / 1 ps

module iob_t2p_mem #(
		      parameter MEM_INIT_FILE="none",
		      parameter DATA_W=32,
		      parameter ADDR_W=11
		      )
   (
    input [(DATA_W-1):0] 	  data_a, data_b,
    input [(ADDR_W-1):0] 	  addr_a, addr_b,
    input 			  en_a, en_b, we_a, we_b, clk,
    output reg [(DATA_W-1):0] q_a, q_b
		    );

   //this allows ISE 14.7 to work; do not remove
   parameter mem_init_file_int = MEM_INIT_FILE;

   
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
