`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}

module gray_counter_asym 
  #(
    parameter   COUNTER_WIDTH = 4
    ) 
   (
    input wire                 rst, //Count reset.
    input wire                 clk,
    input wire                 en, //Count enable.
    output [COUNTER_WIDTH-1:0] data_out
    );

   reg [COUNTER_WIDTH-1:0]                               bin_counter;
   reg [COUNTER_WIDTH-1:0]                               gray_counter;

   assign data_out = gray_counter;
   
   always @ (posedge clk, posedge rst)
     if (rst) begin
        bin_counter   <= 1; 
        gray_counter <= 0; 
     end else if (en) begin
        bin_counter   <= bin_counter + 1'b1;
        gray_counter <= {bin_counter[COUNTER_WIDTH-1], bin_counter[COUNTER_WIDTH-2:0] ^ bin_counter[COUNTER_WIDTH-1:1]};
     end
   
endmodule

module iob_async_fifo_asym
  #(parameter 
    R_DATA_W = 0,
    W_DATA_W = 0,
    ADDR_W = 0, // ADDR_W of smallest DATA_W size
    NAR_ADDR_W = ADDR_W-$clog2(`max(W_DATA_W, R_DATA_W)/`min(W_DATA_W, R_DATA_W)),
    W_ADDR_W = (`max(R_DATA_W, W_DATA_W) == W_DATA_W) ? NAR_ADDR_W : ADDR_W,
    R_ADDR_W = (`max(R_DATA_W, W_DATA_W) == R_DATA_W) ? NAR_ADDR_W : ADDR_W
    )
   (
    input                     rst,

    //read port
    output reg [R_DATA_W-1:0] r_data, 
    output                    r_empty,
    output [R_ADDR_W-1:0]     r_level,
    input                     r_en,
    input                     r_clk, 

    //write port	 
    input [W_DATA_W-1:0]      w_data, 
    output                    w_full,
    output [W_ADDR_W-1:0]     w_level,
    input                     w_en,
    input                     w_clk
    );

   //local variables
   localparam ADDR_W_DIFF = ADDR_W - NAR_ADDR_W;
   localparam W_FIFO_DEPTH = (1 << W_ADDR_W);
   

   
   //WRITE DOMAIN 
   wire [W_ADDR_W-1:0]        wptr;
   reg [R_ADDR_W-1:0]         rptr_sync[1:0];
   wire 		      w_en_int;
   wire [R_ADDR_W-1:0]        rptr_bin;
   wire [W_ADDR_W-1:0]        rptr_wire;
   
   
   //READ DOMAIN    
   wire [R_ADDR_W-1:0]        rptr;
   reg [W_ADDR_W-1:0]         wptr_sync[1:0];
   wire 		      r_en_int;
   wire [W_ADDR_W-1:0]        wptr_bin;
   wire [R_ADDR_W-1:0]        wptr_wire;
   
   
   //convert gray to binary code - Write addresses
   function [W_ADDR_W-1:0] gray2binW;
      input reg [W_ADDR_W-1:0] gr;
      input integer            N;
      begin: g2b
	 reg [W_ADDR_W-1:0] bi;
	 integer            i;
	 
	 bi[N-1] = gr[N-1];
	 for (i=N-2;i>=0;i=i-1)
           bi[i] = gr[i] ^ bi[i+1];
	 
	 gray2binW = bi;
      end
   endfunction
   //convert gray to binary code - Read addresses
   function [R_ADDR_W-1:0] gray2binR;
      input reg [R_ADDR_W-1:0] gr;
      input integer            N;
      begin: g2b
	 reg [R_ADDR_W-1:0] bi;
	 integer            i;
	 
	 bi[N-1] = gr[N-1];
	 for (i=N-2;i>=0;i=i-1)
           bi[i] = gr[i] ^ bi[i+1];
	 
	 gray2binR = bi;
      end
   endfunction
   
   //convert pointers to other domain ADDR_W
   assign rptr_bin = gray2binR(rptr_sync[1], R_ADDR_W);
   assign wptr_bin = gray2binW(wptr_sync[1], W_ADDR_W);

   generate
      if(W_ADDR_W > R_ADDR_W) begin
	 assign rptr_wire = {rptr_bin, {ADDR_W_DIFF{1'b0}}};
	 assign wptr_wire = wptr_bin[W_ADDR_W-1:ADDR_W_DIFF];
      end else if (W_ADDR_W == R_ADDR_W) begin
	 assign rptr_wire = rptr_bin;
	 assign wptr_wire = wptr_bin;
      end else begin
	 assign rptr_wire = rptr_bin[R_ADDR_W-1:ADDR_W_DIFF];
	 assign wptr_wire = {wptr_bin, {ADDR_W_DIFF{1'b0}}};
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
   
   gray_counter_asym 
     #(
       .COUNTER_WIDTH(W_ADDR_W)
       ) 
   wptr_counter 
     (
      .clk(w_clk),
      .rst(rst), 
      .en(w_en_int),
      .data_out(wptr)
      );

   //compute binary pointer difference
   assign w_level = gray2binW(wptr, W_ADDR_W) - rptr_wire;
   
   assign w_full = (w_level == (W_FIFO_DEPTH-1));

   
   //READ DOMAIN LOGIC

   //sync write pointer
   always @ (posedge r_clk) begin 
      wptr_sync[0] <= wptr;
      wptr_sync[1] <= wptr_sync[0];
   end

   //effective read enable
   assign r_en_int  = r_en & ~r_empty;
   
   gray_counter_asym 
     #(
       .COUNTER_WIDTH(R_ADDR_W)
       ) 
   rptr_counter 
     (
      .clk(r_clk),
      .rst(rst), 
      .en(r_en_int),
      .data_out(rptr)
      );
   
   //compute binary pointer difference
   assign r_level = wptr_wire - gray2binR(rptr, R_ADDR_W);
   

   assign r_empty = (r_level == 0);
   
   //
   // FIFO memory
   //

   iob_t2p_asym_ram 
     #(
       .W_DATA_W(W_DATA_W),
       .W_ADDR_W(W_ADDR_W),
       .R_DATA_W(R_DATA_W),
       .R_ADDR_W(R_ADDR_W)
       ) 
   t2p_asym_ram 
     (
      .w_clk(w_clk),
      .w_en(w_en_int),
      .w_data(w_data),
      .w_addr(gray2binW(wptr, W_ADDR_W)),
      .r_clk(r_clk),
      .r_addr(gray2binR(rptr, R_ADDR_W)),
      .r_en(r_en_int),
      .r_data(r_data)
      );
   
endmodule

