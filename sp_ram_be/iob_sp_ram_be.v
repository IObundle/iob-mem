// Single-Port BRAM with Byte-wide Write Enable
// Read-First mode

`timescale 1 ns / 1 ps

module iob_sp_ram_be
  #(
    parameter FILE="none",
    parameter ADDR_WIDTH = 10, // Addr Width in bits : 2*ADDR_WIDTH = RAM Depth
    parameter DATA_WIDTH = 32  // Data Width in bits
    ) 
   ( 
     input                    clk,
     input                    en,
     input [DATA_WIDTH/8-1:0] we,
     input [ADDR_WIDTH-1:0]   addr,
     input [DATA_WIDTH-1:0]   din,
     output [DATA_WIDTH-1:0]  dout
     );

   localparam COL_WIDTH = 8;
   localparam NUM_COL = DATA_WIDTH/COL_WIDTH;

   // Operation
`ifdef MEM_BYTE_EN
   // this allows ISE 14.7 to work; do not remove
   localparam mem_init_file_int = {FILE, ".hex"};

   // Core Memory
   reg [DATA_WIDTH-1:0]       ram_block[(2**ADDR_WIDTH)-1:0];

   // Initialize the RAM
   initial
     if(mem_init_file_int != "none")
       $readmemh(mem_init_file_int, ram_block, 0, 2**ADDR_WIDTH - 1);

   reg [DATA_WIDTH-1:0]       dout_int;
   integer                    i;
   always @ (posedge clk) begin
      if(en) begin
         for(i=0; i < NUM_COL; i=i+1) begin
            if(we[i]) begin
               ram_block[addr][i*COL_WIDTH +: COL_WIDTH] <= din[i*COL_WIDTH +: COL_WIDTH];
            end
         end
         dout_int <= ram_block[addr]; // Send Feedback
      end
   end

   assign dout = dout_int;
`else // !MEM_BYTE_EN
   localparam file_suffix = {"7","6","5","4","3","2","1","0"};

   genvar                     i;
   generate
      for (i=0; i < NUM_COL; i=i+1) begin: ram_col
         localparam mem_init_file_int = (FILE != "none")? {FILE, "_", file_suffix[8*(i+1)-1 -: 8], ".hex"}: "none";

         sp_ram
             #(
               .FILE(mem_init_file_int),
               .ADDR_W(ADDR_WIDTH),
               .DATA_W(COL_WIDTH)
               ) ram
           (
            .clk      (clk),

            .en       (en),
            .addr     (addr),
            .data_in  (din[i*COL_WIDTH +: COL_WIDTH]),
            .we       (we[i]),
            .data_out (dout[i*COL_WIDTH +: COL_WIDTH])
            );
      end
   endgenerate
`endif

endmodule
