`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}


module gray_counter_asym #(
		      parameter   COUNTER_WIDTH = 4
 		      ) (
    input wire                 rst, //Count reset.
    input wire                 clk,
    input wire                 en, //Count enable.
    output [COUNTER_WIDTH-1:0] data_out
    );

   reg [COUNTER_WIDTH-1:0]         bin_counter;
   reg [COUNTER_WIDTH-1:0]         gray_counter;

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
    R_DATA_W = 32,
    W_DATA_W = 32,
    ADDR_W = 8, // ADDR_W of smallest DATA_W size
    NAR_ADDR_W = ADDR_W-$clog2(`max(W_DATA_W, R_DATA_W)/`min(W_DATA_W, R_DATA_W)),
    W_ADDR_W = (`max(R_DATA_W, W_DATA_W) == W_DATA_W) ? NAR_ADDR_W : ADDR_W,
    R_ADDR_W = (`max(R_DATA_W, W_DATA_W) == R_DATA_W) ? NAR_ADDR_W : ADDR_W
    )
   (
    input 		      rst,

    //read port
    output reg [R_DATA_W-1:0] r_data, 
    output 		      empty,
    output [R_ADDR_W-1:0]     level_r,
    input 		      read_en,
    input 		      rclk, 

    //write port	 
    input [W_DATA_W-1:0]      w_data, 
    output 		      full,
    output [W_ADDR_W-1:0]  level_w,
    input 		      write_en,
    input 		      wclk
    );

   //local variables
   localparam ADDR_W_DIFF = ADDR_W - NAR_ADDR_W;
   localparam W_FIFO_DEPTH = (1 << W_ADDR_W);
      

   
   //WRITE DOMAIN 
   wire [W_ADDR_W-1:0] 	      wptr;
   reg [R_ADDR_W-1:0] 	      rptr_sync[1:0];
   wire 		      write_en_int;
   wire [R_ADDR_W-1:0] 	      rptr_bin;
   wire [W_ADDR_W-1:0] 	      rptr_wire;
   wire [W_ADDR_W-1:0]        wptr_bin_w;
   
   
   //READ DOMAIN    
   wire [R_ADDR_W-1:0] 	      rptr;
   reg [W_ADDR_W-1:0] 	      wptr_sync[1:0];
   wire 		      read_en_int;
   wire [W_ADDR_W-1:0] 	      wptr_bin;
   wire [R_ADDR_W-1:0] 	      wptr_wire;
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
   always @ (posedge wclk) begin 
      rptr_sync[0] <= rptr;
      rptr_sync[1] <= rptr_sync[0];
   end
   
   //effective write enable
   assign write_en_int = write_en & ~full;
   
   gray_counter_asym #(
		  .COUNTER_WIDTH(W_ADDR_W)
		  ) wptr_counter (
                                               .clk(wclk),
                                               .rst(rst), 
                                               .en(write_en_int),
                                               .data_out(wptr)
                                               );
   //compute binary pointer difference
   gray2bin #(
       .DATA_W(W_ADDR_W)
   ) gray2bin_wptr_w (
       .gr(wptr),
       .bin(wptr_bin_w)
   );
   assign level_w = wptr_bin_w - rptr_wire;
   
   assign full = (level_w == (W_FIFO_DEPTH-1));

   
   //READ DOMAIN LOGIC

   //sync write pointer
   always @ (posedge rclk) begin 
      wptr_sync[0] <= wptr;
      wptr_sync[1] <= wptr_sync[0];
   end

   //effective read enable
   assign read_en_int  = read_en & ~empty;
   
   gray_counter_asym #(
		  .COUNTER_WIDTH(R_ADDR_W)
		  ) rptr_counter (
                                               .clk(rclk),
                                               .rst(rst), 
                                               .en(read_en_int),
                                               .data_out(rptr)
                                              );
   
   //compute binary pointer difference
   gray2bin #(
       .DATA_W(R_ADDR_W)
   ) gray2bin_rptr_r (
       .gr(rptr),
       .bin(rptr_bin_r)
   );
   assign level_r = wptr_wire - rptr_bin_r;
   

   assign empty = (level_r == 0);
   
   //
   // FIFO memory
   //

   iob_t2p_asym_ram #(
   			    .W_DATA_W(W_DATA_W),
   			    .W_ADDR_W(W_ADDR_W),
   			    .R_DATA_W(R_DATA_W),
   			    .R_ADDR_W(R_ADDR_W)
   			    ) fifo_t2p_asym_ram (
   							.wclk(wclk),
   							.w_en(write_en_int),
   							.w_data(w_data),
   							.w_addr(wptr_bin_w),
   							.rclk(rclk),
   							.r_addr(rptr_bin_r),
   							.r_en(read_en_int),
   							.r_data(r_data)
   							);
   
endmodule
   
