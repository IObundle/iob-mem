`timescale 1ns/1ps

module iob_fifo_sync
  #(parameter
    DATA_W = 0,
    ADDR_W = 0, 
    FIFO_DEPTH = (1 << ADDR_W)
    )
   (
    input                   rst,
    input                   clk,
   
    output reg [ADDR_W-1:0] fifo_ocupancy, 

    //read port
    output [DATA_W-1:0]     r_data, 
    output reg              r_empty,
    input                   r_en,

    //write port	 
    input [DATA_W-1:0]      w_data, 
    output reg              w_full,
    input                   w_en
    );

   //WRITE DOMAIN 
   wire [ADDR_W-1:0] wptr;
   wire                     w_en_int;
   
   //READ DOMAIN    
   wire [ADDR_W-1:0] rptr;
   wire                     r_en_int;


   always @ (posedge clk or posedge rst)
     if (rst) begin
        fifo_ocupancy <= 0;
        r_empty <= 1'b1;
        w_full <= 1'b0;
     end else if (w_en_int & !r_en_int) begin
       fifo_ocupancy <= fifo_ocupancy+1;
        if (fifo_ocupancy == (FIFO_DEPTH-1))
          w_full <= 1'b1;
        if (r_empty)
          r_empty <= 1'b0;
     end else if (r_en_int & !w_en_int) begin
       fifo_ocupancy <= fifo_ocupancy-1;
        if (fifo_ocupancy == 1)
          r_empty <= 1'b1;
        if (w_full)
          w_full <= 1'b0;
     end
   
   //WRITE DOMAIN LOGIC
   //effective write enable
   assign w_en_int = w_en & ~w_full;
   //assign w_full = (fifo_ocupancy == FIFO_DEPTH);
   
   bin_counter 
        #(
            ADDR_W
        ) 
    wptr_counter 
        (
          .clk(clk),
          .rst(rst), 
          .en(w_en_int),
          .data_out(wptr)
        );

   //READ DOMAIN LOGIC
   //effective read enable
   assign r_en_int  = r_en & ~r_empty;
   //assign r_empty = (fifo_ocupancy == 0);
   
   bin_counter 
     #(
       ADDR_W
       ) 
   rptr_counter 
     (
      .clk(clk),
      .rst(rst), 
      .en(r_en_int),
      .data_out(rptr)
      );
   
   
   //FIFO memory
   iob_ram_2p
     #(
       .DATA_W(DATA_W), 
       .ADDR_W(ADDR_W)
       ) 
   fifo_ram
     (
      .clk(clk),
      .w_en(w_en_int),
      .w_data(w_data),
      .w_addr(wptr),
      .r_addr(rptr),
      .r_en(r_en_int),
      .r_data(r_data)
      );

endmodule


