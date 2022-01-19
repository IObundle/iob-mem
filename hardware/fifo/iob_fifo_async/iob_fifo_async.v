`timescale 1ns/1ps

module iob_fifo_async
  #(parameter 
    DATA_WIDTH = 8, 
    ADDRESS_WIDTH = 4
    )
   (
    input                       rst,

    //read port
    input                       r_clk, 
    input                       r_en,
    output reg [DATA_WIDTH-1:0] r_data, 
    output                      r_empty,
    output [ADDRESS_WIDTH-1:0]  r_level,

    //write port   
    input                       w_clk,
    input                       w_en,
    input [DATA_WIDTH-1:0]      w_data, 
    output                      w_full,
    output [ADDRESS_WIDTH-1:0]  w_level
    );

   localparam FIFO_DEPTH = (1 << ADDRESS_WIDTH);
         
   //WRITE DOMAIN 
   wire [ADDRESS_WIDTH-1:0]     wptr;
   reg [ADDRESS_WIDTH-1:0]      rptr_sync[1:0];
   wire                         w_en_int;
   wire [ADDRESS_WIDTH-1:0]     wptr_bin_w;
   wire [ADDRESS_WIDTH-1:0]     rptr_bin_w;
   
   //READ DOMAIN    
   wire [ADDRESS_WIDTH-1:0]     rptr;
   reg [ADDRESS_WIDTH-1:0]      wptr_sync[1:0];
   wire                         r_en_int;
   wire [ADDRESS_WIDTH-1:0]     wptr_bin_r;
   wire [ADDRESS_WIDTH-1:0]     rptr_bin_r;

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
       .COUNTER_WIDTH(ADDRESS_WIDTH)
       ) 
   wptr_counter 
     (
      .clk(w_clk),
      .rst(rst), 
      .en(w_en_int),
      .data_out(wptr)
      );

   //compute binary pointer difference
   gray2bin #(
       .DATA_W(ADDRESS_WIDTH)
   ) 
   gray2bin_wptr_w 
     (
      .gr(wptr),
      .bin(wptr_bin_w)
      );

   gray2bin 
     #(
       .DATA_W(ADDRESS_WIDTH)
       ) 
   gray2bin_rptr_w 
     (
      .gr(rptr_sync[1]),
      .bin(rptr_bin_w)
      );

   assign w_level = wptr_bin_w - rptr_bin_w;
   
   assign w_full = (w_level == (FIFO_DEPTH-1));

   
   //READ DOMAIN LOGIC

   //sync write pointer
   always @ (posedge r_clk) begin 
      wptr_sync[0] <= wptr;
      wptr_sync[1] <= wptr_sync[0];
   end

   //effective read enable
   assign r_en_int  = r_en & ~r_empty;

   gray_counter 
     #(.COUNTER_WIDTH(ADDRESS_WIDTH)) 
   rptr_counter 
     (
      .clk(r_clk),
      .rst(rst), 
      .en(r_en_int),
      .data_out(rptr)
      );
   
   //compute binary pointer difference
   gray2bin 
     #(
       .DATA_W(ADDRESS_WIDTH)
       ) 
   gray2bin_wptr_r 
     (
      .gr(wptr_sync[1]),
      .bin(wptr_bin_r)
      );

   gray2bin 
     #(
       .DATA_W(ADDRESS_WIDTH)
       ) 
   gray2bin_rptr_r 
     (
      .gr(rptr),
      .bin(rptr_bin_r)
      );

   assign r_level = wptr_bin_r - rptr_bin_r;
   

   assign r_empty = (r_level == 0);

   iob_ram_t2p 
     #(
       .DATA_W(DATA_WIDTH),
       .ADDR_W(ADDRESS_WIDTH)
       ) 
   fifo_ram_t2p0 
     (
      .w_clk(w_clk),
      .w_en(w_en_int),
      .w_addr(wptr_bin_w),
      .w_data(w_data),

      .r_clk(r_clk),
      .r_en(r_en_int),
      .r_addr(rptr_bin_r),
      .r_data(r_data)
      );
      
endmodule

