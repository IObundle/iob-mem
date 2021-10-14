// Dual-Port BRAM with Byte-wide Write Enable
// Read-First mode 

`timescale 1 ns / 1 ps

module iob_dp_ram_be
  #(
    parameter FILE = "none",
    parameter ADDR_WIDTH = 10, // Addr Width in bits : 2*ADDR_WIDTH = RAM Depth
    parameter DATA_WIDTH = 32  // Data Width in bits
    )
   (
    input                    clk,

    // Port A
    input                    enA,
    input [DATA_WIDTH/8-1:0] weA,
    input [ADDR_WIDTH-1:0]   addrA,
    input [DATA_WIDTH-1:0]   dinA,
    output [DATA_WIDTH-1:0]  doutA,

    // Port B
    input                    enB,
    input [DATA_WIDTH/8-1:0] weB,
    input [ADDR_WIDTH-1:0]   addrB,
    input [DATA_WIDTH-1:0]   dinB,
    output [DATA_WIDTH-1 :0] doutB
    );

   localparam COL_WIDTH = 8;
   localparam NUM_COL = DATA_WIDTH/COL_WIDTH;

`ifdef IS_CYCLONEV
   localparam file_suffix = {"7","6","5","4","3","2","1","0"};

   genvar                    i;
   generate
      for (i=0; i < NUM_COL; i=i+1) begin: ram_col
         localparam mem_init_file_int = (FILE != "none")? {FILE, "_", file_suffix[8*(i+1)-1 -: 8], ".hex"}: "none";

         iob_dp_ram
             #(
               .FILE(mem_init_file_int),
               .ADDR_W(ADDR_WIDTH),
               .DATA_W(COL_WIDTH)
               ) ram
           (
            .clk    (clk),

            .en_a   (enA),
            .addr_a (addrA),
            .data_a (dinA[i*COL_WIDTH +: COL_WIDTH]),
            .we_a   (weA[i]),
            .q_a    (doutA[i*COL_WIDTH +: COL_WIDTH]),

            .en_b   (enB),
            .addr_b (addrB),
            .data_b (dinB[i*COL_WIDTH +: COL_WIDTH]),
            .we_b   (weB[i]),
            .q_b    (doutB[i*COL_WIDTH +: COL_WIDTH])
            );
      end
   endgenerate
`else // !IS_CYCLONEV
   // this allow ISE 14.7 to work; do not remove
   localparam mem_init_file_int = {FILE, ".hex"};

   // Core Memory
   reg [DATA_WIDTH-1:0]      ram_block[(2**ADDR_WIDTH)-1:0];

   // Initialize the RAM
   initial
     if(mem_init_file_int != "none.hex")
       $readmemh(mem_init_file_int, ram_block, 0, 2**ADDR_WIDTH - 1);

   // Port-A Operation
   reg [DATA_WIDTH-1:0]      doutA_int;
   integer                   i;
   always @(posedge clk) begin
      if (enA) begin
         for (i=0; i < NUM_COL; i=i+1) begin
            if (weA[i]) begin
               ram_block[addrA][i*COL_WIDTH +: COL_WIDTH] <= dinA[i*COL_WIDTH +: COL_WIDTH];
            end
         end
         doutA_int <= ram_block[addrA]; // Send Feedback
      end
   end

   assign doutA = doutA_int;

   // Port-B Operation
   reg [DATA_WIDTH-1:0]      doutB_int;
   integer                   j;
   always @(posedge clk) begin
      if (enB) begin
         for (j=0; j < NUM_COL; j=j+1) begin
            if (weB[j]) begin
               ram_block[addrB][j*COL_WIDTH +: COL_WIDTH] <= dinB[j*COL_WIDTH +: COL_WIDTH];
            end
         end
         doutB_int <= ram_block[addrB]; // Send Feedback
      end
   end

   assign doutB = doutB_int;
`endif

endmodule
