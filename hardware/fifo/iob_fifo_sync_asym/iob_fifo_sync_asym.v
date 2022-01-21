`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_fifo_sync_asym
  #(
    parameter
    W_DATA_W = 0,
    R_DATA_W = 0,
    ADDR_W = 0,//higher ADDR_W (lower DATA_W)
    //determine W_ADDR_W and R_ADDR_W
    MAXDATA_W = `max(W_DATA_W, R_DATA_W),
    MINDATA_W = `min(W_DATA_W, R_DATA_W),
    MINADDR_W = ADDR_W-$clog2(MAXDATA_W/MINDATA_W),//lower ADDR_W (higher DATA_W)
    W_ADDR_W = (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W,
    R_ADDR_W = (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W
    )
   (
    input                 rst,
    input                 clk,

    //read port
    input                 r_en,
    output [R_DATA_W-1:0] r_data,
    output                r_empty,
    output [R_ADDR_W-1:0] r_level,

    //write port
    input                 w_en,
    input [W_DATA_W-1:0]  w_data,
    output                w_full,
    output [W_ADDR_W-1:0] w_level
    );

   //WRITE LOGIC

   assign w_full = (w_level == 2**W_ADDR_W);

   //effective write enable
   wire                   w_en_int = w_en & ~w_full;

   wire [W_ADDR_W-1:0]    wptr;
   bin_counter
     #(
       W_ADDR_W
       )
   wptr_counter
     (
      .clk(clk),
      .rst(rst),
      .en(w_en_int),
      .data_out(wptr)
      );

   //READ LOGIC

   assign r_empty = (r_level == 0);

   //effective read enable
   wire                   r_en_int  = r_en & ~r_empty;

   wire [R_ADDR_W-1:0]    rptr;
   bin_counter
     #(
       R_ADDR_W
       )
   rptr_counter
     (
      .clk(clk),
      .rst(rst),
      .en(r_en_int),
      .data_out(rptr)
      );


   //compute FIFO levels
   localparam ADDR_W_DIFF = ADDR_W - MINADDR_W;
   wire [R_ADDR_W-1:0]    wptr_rside;
   wire [W_ADDR_W-1:0]    rptr_wside;

    generate
      if(W_ADDR_W > R_ADDR_W) begin
	 assign rptr_wside = {rptr, {ADDR_W_DIFF{1'b0}}};
	 assign wptr_rside = wptr[W_ADDR_W-1:ADDR_W_DIFF];
      end else if (W_ADDR_W == R_ADDR_W) begin
	 assign rptr_wside = rptr;
	 assign wptr_rside = wptr;
      end else begin //W_ADDR_W < R_ADDR_W
	 assign rptr_wside = rptr[R_ADDR_W-1:ADDR_W_DIFF];
	 assign wptr_rside = {wptr, {ADDR_W_DIFF{1'b0}}};
      end
   endgenerate

   assign w_level = wptr - rptr_wside;
   assign r_level = wptr_rside - rptr;

   //FIFO memory
   iob_ram_2p_asym
     #(
       .W_DATA_W(W_DATA_W),
       .R_DATA_W(R_DATA_W),
       .ADDR_W(ADDR_W)
       )
   fifo_ram
     (
      .clk(clk),

      .w_en(w_en_int),
      .w_data(w_data),
      .w_addr(wptr),

      .r_en(r_en_int),
      .r_addr(rptr),
      .r_data(r_data)
      );

endmodule
