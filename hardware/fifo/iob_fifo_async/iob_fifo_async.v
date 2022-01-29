`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_fifo_async
  #(parameter
    W_DATA_W = 0,
    R_DATA_W = 0,
    ADDR_W = 0 //higher ADDR_W lower DATA_W
    )
   (
    input                     rst,

    //read port
    input                     r_clk,
    input                     r_en,
    output reg [R_DATA_W-1:0] r_data,
    output reg                r_empty,
    output reg                r_full,
    output reg [ADDR_W:0]     r_level,

    //write port
    input                     w_clk,
    input                     w_en,
    input [W_DATA_W-1:0]      w_data,
    output reg                w_empty,
    output reg                w_full,
    output reg [ADDR_W:0]     w_level

    );

    //determine W_ADDR_W and R_ADDR_W
   localparam MAXDATA_W = `max(W_DATA_W, R_DATA_W);
   localparam MINDATA_W = `min(W_DATA_W, R_DATA_W);
   localparam R = MAXDATA_W/MINDATA_W;
   localparam ADDR_W_DIFF = $clog2(R);
   localparam MINADDR_W = ADDR_W-$clog2(R);//lower ADDR_W (higher DATA_W)
   localparam W_ADDR_W = (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W;
   localparam R_ADDR_W = (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W;
   localparam [ADDR_W:0] FIFO_SIZE = (1'b1 << ADDR_W); //in bytes


   //read/write increments
   wire [ADDR_W-1:0]          r_incr, w_incr;

   //binary read addresses on both domains
   wire [R_ADDR_W-1:0]        r_addr_bin, w_r_addr_bin;
   wire [W_ADDR_W-1:0]        w_addr_bin, r_w_addr_bin;

   //normalized addresses
   wire [ADDR_W-1:0]          w_addr_bin_n, r_addr_bin_n;
   wire [ADDR_W-1:0]          r_w_addr_bin_n, w_r_addr_bin_n;

   //assign according to assymetry type
   generate
      if (W_DATA_W > R_DATA_W) begin
         assign r_incr = 1'b1;
         assign w_incr = 1'b1 << ADDR_W_DIFF;
         assign r_w_addr_bin_n = r_w_addr_bin<<ADDR_W_DIFF;
         assign w_r_addr_bin_n = w_r_addr_bin;
         assign w_addr_bin_n = w_addr_bin<<ADDR_W_DIFF;
         assign r_addr_bin_n = r_addr_bin;
      end else if (R_DATA_W > W_DATA_W) begin
         assign w_incr = 1'b1;
         assign r_incr = 1'b1 << ADDR_W_DIFF;
         assign r_w_addr_bin_n = r_w_addr_bin;
         assign w_r_addr_bin_n = w_r_addr_bin<<ADDR_W_DIFF;
         assign w_addr_bin_n = w_addr_bin;
         assign r_addr_bin_n = r_addr_bin<<ADDR_W_DIFF;
      end else begin
         assign r_incr = 1'b1;
         assign w_incr = 1'b1;
         assign r_w_addr_bin_n = r_w_addr_bin;
         assign w_r_addr_bin_n = w_r_addr_bin;
         assign w_addr_bin_n = w_addr_bin;
         assign r_addr_bin_n = r_addr_bin;
      end
   endgenerate


   //sync write address to read domain
   wire [W_ADDR_W-1:0]        w_addr;
   reg [W_ADDR_W-1:0]         r_w_addr[1:0];
   always @ (posedge r_clk) begin
      r_w_addr[0] <= w_addr;
      r_w_addr[1] <= r_w_addr[0];
   end


   //sync read address to write domain
   wire [R_ADDR_W-1:0] 	      r_addr;
   reg [R_ADDR_W-1:0] 	      w_r_addr[1:0];
   always @ (posedge w_clk) begin
      w_r_addr[0] <= r_addr;
      w_r_addr[1] <= w_r_addr[0];
   end


   //READ DOMAIN FIFO INFO
   wire [ADDR_W-1:0]      r_level_int = r_w_addr_bin_n - r_addr_bin_n;

   //read state (gray encoded)
   localparam INIT=3, EMPTY=1, DEFAULT=0, FULL=2;
   reg [1:0]              r_st, r_st_nxt;
   `REG_AR(r_clk, rst, INIT, r_st, r_st_nxt)

   //read state machine
   `COMB begin
      r_level = r_level_int;
      r_full = 1'b0;
      r_empty = 1'b0;
      r_st_nxt = r_st;

      case (r_st)

        INIT: begin
           r_full = 1'b1;
           r_empty = 1'b1;
        end
        
        EMPTY: begin
           r_empty = 1'b1;
           if(r_level_int >= r_incr)
             r_st_nxt = DEFAULT;
        end

        default: begin
           if(r_en && (r_level_int-r_incr) < r_incr)
             r_st_nxt = EMPTY;
           else if(r_level_int > (FIFO_SIZE-w_incr) || r_level_int == 0)
             r_st_nxt = FULL;
        end

        FULL: begin
           r_full = 1'b1;
           r_level = FIFO_SIZE;
           if(r_en && (r_level_int-r_incr) <= (FIFO_SIZE-w_incr))
             r_st_nxt = DEFAULT;
        end

      endcase

   end

   //WRITE DOMAIN FIFO INFO
   wire [ADDR_W-1:0]      w_level_int = w_addr_bin_n - w_r_addr_bin_n;

   //write state
   reg [1:0]              w_st, w_st_nxt;
   `REG_AR(w_clk, rst, INIT, w_st, w_st_nxt)

   `COMB begin
      w_level = w_level_int;
      w_full = 1'b0;
      w_empty = 1'b0;
      w_st_nxt = w_st;

      case (w_st)

        INIT: begin
           w_full = 1'b1;
           w_empty = 1'b1;
        end
        
        EMPTY: begin
           w_empty = 1'b1;
           if( w_en && (w_level_int + w_incr) >= r_incr )
             w_st_nxt = DEFAULT;
        end

        DEFAULT: begin
           if( w_en && (w_level_int + w_incr) > (FIFO_SIZE-w_incr)  )
              w_st_nxt = FULL;
           else if (w_level_int < r_incr)
              w_st_nxt = EMPTY;
        end

        FULL: begin
           w_full = 1'b1;
           w_level = FIFO_SIZE;
           if(w_level_int != 0 && w_level_int <= (FIFO_SIZE-w_incr))
              w_st_nxt = DEFAULT;
        end

      endcase
   end

   //read address gray code counter
   wire r_en_int  = r_en & ~r_empty;
   gray_counter
     #(
       .W(R_ADDR_W)
       )
   r_addr_counter
     (
      .clk(r_clk),
      .rst(rst),
      .en(r_en_int),
      .data_out(r_addr)
      );

   //write address gray code counter
   wire w_en_int = w_en & ~w_full;
   gray_counter
     #(
       .W(W_ADDR_W)
       )
   w_addr_counter
     (
      .clk(w_clk),
      .rst(rst),
      .en(w_en_int),
      .data_out(w_addr)
      );

   //convert gray read address to binary
   gray2bin
     #(
       .DATA_W(R_ADDR_W)
       )
   gray2bin_r_addr
     (
      .gr(r_addr),
      .bin(r_addr_bin)
      );

   //convert synced gray write address to binary
   gray2bin
     #(
       .DATA_W(W_ADDR_W)
       )
   gray2bin_r_addr_sync
     (
      .gr(r_w_addr[1]),
      .bin(r_w_addr_bin)
      );

   //convert gray write address to binary
   gray2bin
     #(
       .DATA_W(W_ADDR_W)
       )
   gray2bin_w_addr
     (
      .gr(w_addr),
      .bin(w_addr_bin)
      );

   //convert synced gray read address to binary
   gray2bin
     #(
       .DATA_W(R_ADDR_W)
       )
   gray2bin_w_addr_sync
     (
      .gr(w_r_addr[1]),
      .bin(w_r_addr_bin)
      );

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
      .w_addr(w_addr_bin),

      .r_clk(r_clk),
      .r_addr(r_addr_bin),
      .r_en(r_en_int),
      .r_data(r_data)
      );

endmodule
