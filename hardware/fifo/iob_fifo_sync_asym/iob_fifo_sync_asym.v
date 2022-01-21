`timescale 1ns/1ps
`include "iob_lib.vh"

module iob_fifo_sync_asym
  #(
    parameter 
    W_DATA_W = 0,
    R_DATA_W = 0,
    ADDR_W = 0 //higher ADDR_W (lower DATA_W)
    )
   (
    input                 rst,
    input                 clk,

    //read port
    input                 r_en,
    output [R_DATA_W-1:0] r_data,
    output reg            r_empty,
    output [ADDR_W-1:0]   r_level,

    //write port
    input                 w_en,
    input [W_DATA_W-1:0]  w_data,
    output reg            w_full,
    output [ADDR_W-1:0]   w_level
    );


    //determine W_ADDR_W and R_ADDR_W
   localparam MAXDATA_W = `max(W_DATA_W, R_DATA_W);
   localparam MINDATA_W = `min(W_DATA_W, R_DATA_W);
   localparam R = MAXDATA_W/MINDATA_W;
   localparam MINADDR_W = ADDR_W-$clog2(R);//lower ADDR_W (higher DATA_W)
   localparam W_ADDR_W = (W_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W;
   localparam R_ADDR_W = (R_DATA_W == MAXDATA_W) ? MINADDR_W : ADDR_W;
   

   
   //
   //WRITE LOGIC
   //
   
   //effective write enable
   wire                   w_en_int = w_en & ~w_full;


   //write address
   `VAR(w_addr, W_ADDR_W)
   `COUNTER_ARE(clk, rst, w_en_int, w_addr)

   //
   //READ LOGIC
   //

   //effective read enable
   wire                   r_en_int  = r_en & ~r_empty;

   //read address
   `VAR(r_addr, R_ADDR_W)
   `COUNTER_ARE(clk, rst, r_en_int, r_addr)



   //compute FIFO levels 
   localparam ADDR_W_DIFF = ADDR_W - MINADDR_W;

   wire [ADDR_W-1:0]    w_addr_n;
   wire [ADDR_W-1:0]    r_addr_n;

   generate
      if(W_ADDR_W > R_ADDR_W) begin
	 assign r_addr_n = r_addr << ADDR_W_DIFF;
	 assign w_addr_n = w_addr;
      end else if (W_ADDR_W == R_ADDR_W) begin
	 assign r_addr_n = r_addr;
	 assign w_addr_n = w_addr;
      end else begin //W_ADDR_W < R_ADDR_W
	 assign r_addr_n = r_addr;
	 assign w_addr_n = w_addr << ADDR_W_DIFF;
      end
   endgenerate

   wire [ADDR_W:0] level;
   reg [ADDR_W:0]  level_nxt;
   assign level = w_addr_n - r_addr_n;
   assign w_level = level[ADDR_W-1:0];
   assign r_level = level[ADDR_W-1:0];

   
   //compute address increments
   wire [ADDR_W-1:0] w_incr = W_DATA_W > R_DATA_W? R:1;
   wire [ADDR_W-1:0] r_incr = R_DATA_W > W_DATA_W? R:1;
   

   //compute hypothetical next level
   `COMB begin
      level_nxt = level;
      if(w_en && !r_en)
        level_nxt = level + w_incr;
      else if (w_en && r_en)
        level_nxt = level + w_incr - r_incr;
      else if (!w_en && r_en)
        level_nxt = level - r_incr;
   end

   wire [ADDR_W:0] fifo_depth = 1'b1 << ADDR_W;
   
   reg             w_full_nxt, r_empty_nxt;
   `REG_AR(clk, rst, 1'b0, w_full, w_full_nxt)
   `REG_AR(clk, rst, 1'b1, r_empty, r_empty_nxt)
   
   `COMB begin
      w_full_nxt = w_full;
      if(!w_full && (level_nxt > (fifo_depth-w_incr)) )
        w_full_nxt = 1'b1;
      else if (w_full && (level_nxt <= (fifo_depth-w_incr)) )
        w_full_nxt = 1'b0;

      r_empty_nxt = r_empty;
      if(!r_empty && (level_nxt < r_incr))
        r_empty_nxt = 1'b1;
      else if (r_empty && (level_nxt >= r_incr))
        r_empty_nxt = 1'b0;
   end
  
   //FIFO memory
   iob_ram_2p_asym
     #(
       .W_DATA_W(W_DATA_W),
       .R_DATA_W(R_DATA_W),
       .MAXADDR_W(ADDR_W)
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
