`timescale 1 ns / 1 ps

module iob_sp_reg_file
  #(
    parameter ADDR_W = 2,
    parameter DATA_W = 32
    )
   (
    input               clk,
    input               rst,

    input               we,
    input [ADDR_W-1:0]  addr,
    input [DATA_W-1:0]  w_data,
    output [DATA_W-1:0] r_data
    );

   reg [DATA_W-1:0]     reg_file [2**ADDR_W-1:0];

   //read
   assign r_data = reg_file[addr];

   //write
   genvar               i;
   generate
      always @(posedge clk)
        if (rst)
          for (i=0; i < 2**ADDR_W; i=i+1) begin: rst_loop
             reg_file[i] <= {DATA_W{1'b0}};
          end
        else if (we)
          reg_file[addr] <= w_data;
   endgenerate

endmodule
