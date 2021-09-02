`timescale 1 ns / 1 ps

module iob_dp_reg_file
  #(
    parameter ADDR_W = 2,
    parameter DATA_W = 32
    )
   (
    input                clk,
    input                rst,

    // Port A
    input [ADDR_W-1:0]   addrA,
    input [DATA_W-1:0]   wdataA,
    input                weA,
    output [DATA_W-1 :0] rdataA,

    // Port B
    input [ADDR_W-1:0]   addrB,
    input [DATA_W-1:0]   wdataB,
    input                weB,
    output [DATA_W-1 :0] rdataB
    );

   // Implementation as 2-port distributed RAM needs two reg files
   reg [DATA_W-1:0]      reg_file_1 [2**ADDR_W-1:0];
   reg [DATA_W-1:0]      reg_file_2 [2**ADDR_W-1:0];

   wire [ADDR_W-1:0]     addr  = weA? addrA : addrB;
   wire [DATA_W-1:0]     wdata = weA? wdataA : wdataB;
   wire                  we    = weA | weB;

   integer               i;

   assign rdataA = reg_file_1[addrA];
   assign rdataB = reg_file_2[addrB];

   always @(posedge clk) begin
      if (rst) begin
         for (i=0; i < 2**ADDR_W; i=i+1) begin
            reg_file_1[i] <= {DATA_W{1'b0}};
            reg_file_2[i] <= {DATA_W{1'b0}};
         end
      end else if (we) begin
         reg_file_1[addr] <= wdata;
         reg_file_2[addr] <= wdata;
      end
   end

endmodule
