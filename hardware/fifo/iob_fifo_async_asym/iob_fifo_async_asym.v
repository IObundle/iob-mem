`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_fifo_async_asym
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
   wire 		      w_en_int;
   wire [W_ADDR_W-1:0] 	      write_addr;
   wire [W_ADDR_W-1:0]        write_addr_bin;
   reg [R_ADDR_W-1:0] 	      read_addr_sync[1:0];
   wire [R_ADDR_W-1:0] 	      read_addr_bin_w;
   wire [W_ADDR_W-1:0] 	      read_addr_bin_w_n;
   
   
   //READ DOMAIN    
   wire 		      r_en_int;
   wire [R_ADDR_W-1:0] 	      read_addr;
   wire [R_ADDR_W-1:0]        read_addr_bin;
   reg [W_ADDR_W-1:0] 	      write_addr_sync[1:0];
   wire [W_ADDR_W-1:0] 	      write_addr_bin_r;
   wire [R_ADDR_W-1:0] 	      write_addr_bin_r_n;

   
   
   //convert addresses from gray to binary code
   gray2bin 
     #(
       .DATA_W(R_ADDR_W)
       ) 
   gray2bin_read_addr_sync 
     (
      .gr(read_addr_sync[1]),
      .bin(read_addr_bin_w)
      );

   gray2bin 
     #(
       .DATA_W(W_ADDR_W)
       ) 
   gray2bin_write_addr_sync 
     (
      .gr(write_addr_sync[1]),
      .bin(write_addr_bin_r)
      );

   //normalise addresses from write (read) to read (write) sizes
   generate
      if(W_ADDR_W > R_ADDR_W) begin
	 assign read_addr_bin_w_n = {read_addr_bin_w, {ADDR_W_DIFF{1'b0}}};
	 assign write_addr_bin_r_n = write_addr_bin_r[W_ADDR_W-1:ADDR_W_DIFF];
      end else if (W_ADDR_W == R_ADDR_W) begin
	 assign read_addr_bin_w_n = read_addr_bin_w;
	 assign write_addr_bin_r_n = write_addr_bin_r;
      end else begin //W_ADDR_W < R_ADDR_W
	 assign read_addr_bin_w_n = read_addr_bin_w[R_ADDR_W-1:ADDR_W_DIFF];
	 assign write_addr_bin_r_n = {write_addr_bin_r, {ADDR_W_DIFF{1'b0}}};
      end
   endgenerate



   //WRITE DOMAIN LOGIC

   //sync gray read pointer to write domain
   always @ (posedge w_clk) begin 
      read_addr_sync[0] <= read_addr;
      read_addr_sync[1] <= read_addr_sync[0];
   end
   
   //effective write enable
   assign w_en_int = w_en & ~w_full;

   //write address gray code counter
   gray_counter 
     #(
       .W(W_ADDR_W)
       ) 
   write_addr_counter 
     (
      .clk(w_clk),
      .rst(rst), 
      .en(w_en_int),
      .data_out(write_addr)
      );

   //compute write side info
   gray2bin 
     #(
       .DATA_W(W_ADDR_W)
       ) 
   gray2bin_write_addr 
     (
      .gr(write_addr),
      .bin(write_addr_bin)
      );

   assign w_level = write_addr_bin - read_addr_bin_w_n;
   assign w_full = (w_level == (W_FIFO_DEPTH-1));
   
   //READ DOMAIN LOGIC

   //sync write pointer
   always @ (posedge r_clk) begin 
      write_addr_sync[0] <= write_addr;
      write_addr_sync[1] <= write_addr_sync[0];
   end

   //effective read enable
   assign r_en_int  = r_en & ~r_empty;

   //read address gray code counter
   gray_counter
     #(
       .W(R_ADDR_W)
       ) 
   read_addr_counter 
     (
      .clk(r_clk),
      .rst(rst), 
      .en(r_en_int),
      .data_out(read_addr)
      );
   
   //compute read side info
   gray2bin 
     #(
       .DATA_W(R_ADDR_W)
       ) 
   gray2bin_read_addr
     (
      .gr(read_addr),
      .bin(read_addr_bin)
      );
   
   assign r_level = write_addr_bin_r_n - read_addr_bin;
   assign r_empty = (r_level == 0);
   

   // FIFO memory
   iob_ram_t2p_asym
     #(
       .W_DATA_W(W_DATA_W),
       .R_DATA_W(R_DATA_W),
       .ADDR_W(ADDR_W)
       ) 
   t2p_asym_ram 
     (
      .w_clk(w_clk),
      .w_en(w_en_int),
      .w_data(w_data),
      .w_addr(write_addr_bin),
      
      .r_clk(r_clk),
      .r_addr(read_addr_bin),
      .r_en(r_en_int),
      .r_data(r_data)
      );
   
endmodule


