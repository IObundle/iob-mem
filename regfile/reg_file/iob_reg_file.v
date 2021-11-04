`timescale 1 ns / 1 ps

module iob_reg_file
  #(
    parameter ADDR_W = 2,
    parameter DATA_W = 32
    )
   (
    input               clk,
    input               rst,

    input               we,
    input [ADDR_W-1:0]  addr,
    input [DATA_W-1:0]  wdata,
    output [DATA_W-1:0] rdata
    );

   reg [DATA_W-1:0]     reg_file [2**ADDR_W-1:0];

   //read
   assign rdata = reg_file[addr];

   //write
   integer              i;
   always @(posedge clk)
     if (rst)
       for (i=0; i < 2**ADDR_W; i=i+1)
         reg_file[i] <= {DATA_W{1'b0}};
     else if (we)
       reg_file[addr] <= wdata;

endmodule
