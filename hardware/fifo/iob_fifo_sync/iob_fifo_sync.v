`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_fifo_sync
  #(
    parameter
    W_DATA_W = 0,
    R_DATA_W = 0,
    ADDR_W = 0, //higher ADDR_W lower DATA_W
    //determine W_ADDR_W and R_ADDR_W
    MAXDATA_W = `IOB_MAX(W_DATA_W, R_DATA_W),
    MINDATA_W = `IOB_MIN(W_DATA_W, R_DATA_W),
    N = MAXDATA_W/MINDATA_W,
    MINADDR_W = ADDR_W-$clog2(N),//lower ADDR_W (higher DATA_W)
    W_ADDR_W = (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W,
    R_ADDR_W = (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
    )
   (
    input                 arst,
    input                 rst,
    input                 clk,
    
`ifdef IOB_EXPORT_MEM
    //write port
    output [N-1:0]            ext_mem_w_en,
    output [W_DATA_W-1:0]     ext_mem_w_data,
    output [W_ADDR_W-1:0]     ext_mem_w_addr,
    //read port
    output                    ext_mem_r_en,
    output [R_ADDR_W-1:0]     ext_mem_r_addr,
    input [R_DATA_W-1:0]      ext_mem_r_data,
`endif

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

   localparam ADDR_W_DIFF = $clog2(N);
   localparam [ADDR_W:0] FIFO_SIZE = (1'b1 << ADDR_W); //in bytes

   //effective write enable
   wire                   w_en_int = w_en & ~w_full;

   //write address
   `IOB_VAR(w_addr, W_ADDR_W)
   `IOB_COUNTER_ARRE(clk, arst, rst, w_en_int, w_addr)

   //effective read enable
   wire                   r_en_int  = r_en & ~r_empty;

   //read address
   `IOB_VAR(r_addr, R_ADDR_W)
   `IOB_COUNTER_ARRE(clk, arst, rst, r_en_int, r_addr)

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
   `IOB_REG_ARR(clk, arst, 1'b0, rst, 1'b0, level, level_nxt)

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
       .W_DATA_W  (W_DATA_W),
       .R_DATA_W  (R_DATA_W),
       .ADDR_W    (ADDR_W)
       )
    iob_ram_2p_asym0
     (
      .clk           (clk),
      
`ifdef IOB_EXPORT_MEM
      .ext_mem_w_en  (ext_mem_w_en),
      .ext_mem_w_data(ext_mem_w_data),
      .ext_mem_w_addr(ext_mem_w_addr),
      .ext_mem_r_en  (ext_mem_r_en),
      .ext_mem_r_addr(ext_mem_r_addr),
      .ext_mem_r_data(ext_mem_r_data),
`endif
      .w_en          (w_en_int),
      .w_data        (w_data),
      .w_addr        (w_addr),

      .r_en          (r_en_int),
      .r_addr        (r_addr),
      .r_data        (r_data)
      );

endmodule
