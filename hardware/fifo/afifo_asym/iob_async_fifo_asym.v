`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_async_fifo_asym
  #(parameter 
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
    input                     rst,

    //read port
    input                     r_clk, 
    input                     r_en,
    output reg [R_DATA_W-1:0] r_data, 
    output                    r_empty,
    output [R_ADDR_W-1:0]     r_level,

    //write port	 
    input                     w_clk,
    input                     w_en,
    input [W_DATA_W-1:0]      w_data, 
    output                    w_full,
    output [W_ADDR_W-1:0]     w_level

    );

   //local variables
   localparam ADDR_W_DIFF = ADDR_W - MINADDR_W;
   localparam W_FIFO_DEPTH = (1 << W_ADDR_W);
   

   
   //WRITE DOMAIN 
   wire [W_ADDR_W-1:0] 	      wptr;
   reg [R_ADDR_W-1:0] 	      rptr_sync[1:0];
   wire 		      w_en_int;
   wire [R_ADDR_W-1:0] 	      rptr_bin;
   wire [W_ADDR_W-1:0] 	      rptr_wside;
   wire [W_ADDR_W-1:0]        wptr_bin_w;
   
   
   //READ DOMAIN    
   wire [R_ADDR_W-1:0] 	      rptr;
   reg [W_ADDR_W-1:0] 	      wptr_sync[1:0];
   wire 		      r_en_int;
   wire [W_ADDR_W-1:0] 	      wptr_bin;
   wire [R_ADDR_W-1:0] 	      wptr_rside;
   wire [R_ADDR_W-1:0]        rptr_bin_r;
   
   
   //convert pointers to other domain ADDR_W
   gray2bin #(
       .DATA_W(R_ADDR_W)
   ) gray2bin_rptr_sync (
       .gr(rptr_sync[1]),
       .bin(rptr_bin)
   );
   gray2bin #(
       .DATA_W(W_ADDR_W)
   ) gray2bin_wptr_sync (
       .gr(wptr_sync[1]),
       .bin(wptr_bin)
   );

   generate
      if(W_ADDR_W > R_ADDR_W) begin
	 assign rptr_wside = {rptr_bin, {ADDR_W_DIFF{1'b0}}};
	 assign wptr_rside = wptr_bin[W_ADDR_W-1:ADDR_W_DIFF];
      end else if (W_ADDR_W == R_ADDR_W) begin
	 assign rptr_wside = rptr_bin;
	 assign wptr_rside = wptr_bin;
      end else begin //W_ADDR_W < R_ADDR_W
	 assign rptr_wside = rptr_bin[R_ADDR_W-1:ADDR_W_DIFF];
	 assign wptr_rside = {wptr_bin, {ADDR_W_DIFF{1'b0}}};
      end
   endgenerate



   //WRITE DOMAIN LOGIC

   //sync read pointer
   always @ (posedge w_clk) begin 
      rptr_sync[0] <= rptr;
      rptr_sync[1] <= rptr_sync[0];
   end
   
   //effective write enable
   assign w_en_int = w_en & ~w_full;
   
   gray_counter 
     #(
       .W(W_ADDR_W)
       ) 
   wptr_counter 
     (
      .clk(w_clk),
      .rst(rst), 
      .en(w_en_int),
      .data_out(wptr)
      );

   //compute FIFO levels 
   gray2bin #(
       .DATA_W(W_ADDR_W)
   ) 
   gray2bin_wptr_w 
     (
      .gr(wptr),
      .bin(wptr_bin_w)
      );

   assign w_level = wptr_bin_w - rptr_wside;
   assign w_full = (w_level == (W_FIFO_DEPTH-1));
   
   //READ DOMAIN LOGIC

   //sync write pointer
   always @ (posedge r_clk) begin 
      wptr_sync[0] <= wptr;
      wptr_sync[1] <= wptr_sync[0];
   end

   //effective read enable
   assign r_en_int  = r_en & ~r_empty;
   
   gray_counter
     #(
       .W(R_ADDR_W)
       ) 
   rptr_counter 
     (
      .clk(r_clk),
      .rst(rst), 
      .en(r_en_int),
      .data_out(rptr)
      );
   
   //compute binary pointer difference
   gray2bin #(
       .DATA_W(R_ADDR_W)
   ) 
   gray2bin_rptr_r 
     (
      .gr(rptr),
      .bin(rptr_bin_r)
      );
   
   assign r_level = wptr_rside - rptr_bin_r;
   assign r_empty = (r_level == 0);
   

   // FIFO memory
   iob_t2p_asym_ram 
     #(
       .W_DATA_W(W_DATA_W),
       .R_DATA_W(R_DATA_W),
       .MAXADDR_W(ADDR_W)
       ) 
   t2p_asym_ram 
     (
      .w_clk(w_clk),
      .w_en(w_en_int),
      .w_data(w_data),
      .w_addr(wptr_bin_w),
      
      .r_clk(r_clk),
      .r_addr(rptr_bin_r),
      .r_en(r_en_int),
      .r_data(r_data)
      );
   
endmodule


