`timescale 1 ns / 1 ps

module iob_tdp_ram
  #(
    parameter FILE="none",
    parameter DATA_W=32,
    parameter ADDR_W=11
    )
   (
    // Port A
    input                     clk_a,
    input [(DATA_W-1):0]      data_a,
    input [(ADDR_W-1):0]      addr_a,
    input                     en_a,
    input                     we_a,
    output reg [(DATA_W-1):0] q_a,

    // Port B
    input                     clk_b,
    input [(DATA_W-1):0]      data_b,
    input [(ADDR_W-1):0]      addr_b,
    input                     en_b,
    input                     we_b,
    output reg [(DATA_W-1):0] q_b
    );

   //this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = FILE;


   // Declare the RAM
   reg [DATA_W-1:0] 			       ram[2**ADDR_W-1:0];

   // Initialize the RAM
   initial
     if(mem_init_file_int != "none")
       $readmemh(mem_init_file_int, ram, 0, 2**ADDR_W - 1);

   always @ (posedge clk_a) begin// Port A
      if (en_a)
        if (we_a)
	        ram[addr_a] <= data_a;
      `ifdef IS_CYCLONEV
        else
      `endif
      q_a <= ram[addr_a];
    end

   always @ (posedge clk_b) begin // Port B
      if (en_b)
        if (we_b)
	        ram[addr_b] <= data_b;
      `ifdef IS_CYCLONEV
        else
      `endif
	    q_b <= ram[addr_b];
    end
 endmodule
