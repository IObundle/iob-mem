`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_fifo_sync
  #(
    parameter
    W_DATA_W = 0,
    R_DATA_W = 0,
    ADDR_W = 0 //higher ADDR_W lower DATA_W
    )
   (
    input                 rst,
    input                 clk,

    //read port
    input                 r_en,
    output [R_DATA_W-1:0] r_data,
    output                r_empty,

    //write port
    input                 w_en,
    input [W_DATA_W-1:0]  w_data,
    output                w_full,

    //FIFO level
    output reg [ADDR_W:0] level
    );


    //determine W_ADDR_W and R_ADDR_W
   localparam MAXDATA_W = `iob_max(W_DATA_W, R_DATA_W);
   localparam MINDATA_W = `min(W_DATA_W, R_DATA_W);
   localparam R = MAXDATA_W/MINDATA_W;
   localparam ADDR_W_DIFF = $clog2(R);
   localparam MINADDR_W = ADDR_W-$clog2(R);//lower ADDR_W (higher DATA_W)
   localparam W_ADDR_W = (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W;
   localparam R_ADDR_W = (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W;
   localparam [ADDR_W:0] FIFO_SIZE = (1'b1 << ADDR_W); //in bytes

   //effective write enable
   wire                   w_en_int = w_en & ~w_full;

   //write address
   `IOB_VAR(w_addr, W_ADDR_W)
   `IOB_COUNTER_RE(clk, rst, w_en_int, w_addr)

   //effective read enable
   wire                   r_en_int  = r_en & ~r_empty;

   //read address
   `IOB_VAR(r_addr, R_ADDR_W)
   `IOB_COUNTER_RE(clk, rst, r_en_int, r_addr)

   //assign according to assymetry type
   wire [ADDR_W-1:0]       r_incr, w_incr;
   generate
      if (W_DATA_W > R_DATA_W) begin
        assign r_incr = 1'b1;
        assign w_incr = 1'b1 << ADDR_W_DIFF;
      end else if (R_DATA_W > W_DATA_W) begin
        assign w_incr = 1'b1;
        assign r_incr = 1'b1 << ADDR_W_DIFF;
      end else begin
        assign r_incr = 1'b1;
        assign w_incr = 1'b1;
      end
   endgenerate

   //FIFO level
   reg [ADDR_W:0]         level_nxt;
   `IOB_REG_R(clk, rst, 1'b0, level, level_nxt)

   `IOB_COMB begin
      level_nxt = level;
      if(w_en_int && !r_en_int)
        level_nxt = level + w_incr;
      else if(w_en_int && r_en_int)
             level_nxt = level + w_incr -r_incr;
      else if (!w_en_int && r_en_int)
        level_nxt = level -r_incr;
   end

   //FIFO empty
   assign r_empty = level < r_incr;

   //FIFO full
   assign w_full = level > (FIFO_SIZE -w_incr);

   //FIFO memory
   iob_ram_2p_asym
     #(
       .W_DATA_W(W_DATA_W),
       .R_DATA_W(R_DATA_W),
       .ADDR_W(ADDR_W)
       )
    iob_ram_2p_asym0
     (
      .clk(clk),

      .w_en(w_en_int),
      .w_data(w_data),
      .w_addr(w_addr),

      .r_en(r_en_int),
      .r_addr(r_addr),
      .r_data(r_data)
      );

endmodule
