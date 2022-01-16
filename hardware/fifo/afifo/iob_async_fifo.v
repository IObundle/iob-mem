`timescale 1ns/1ps

module gray_counter #(parameter   COUNTER_WIDTH = 4)
   (
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

module iob_async_fifo
  #(parameter 
    DATA_WIDTH = 8, 
    ADDRESS_WIDTH = 4
    )
   (
    input                       rst,

    //read port
    output reg [DATA_WIDTH-1:0] r_data, 
    output                      empty,
    output [ADDRESS_WIDTH-1:0]  level_r,
    input                       read_en,
    input                       rclk, 

    //write port   
    input [DATA_WIDTH-1:0]      w_data, 
    output                      full,
    output [ADDRESS_WIDTH-1:0]  level_w,
    input                       write_en,
    input                       wclk
    );

   localparam FIFO_DEPTH = (1 << ADDRESS_WIDTH);
         
   //WRITE DOMAIN 
   wire [ADDRESS_WIDTH-1:0]     wptr;
   reg [ADDRESS_WIDTH-1:0]      rptr_sync[1:0];
   wire                         write_en_int;
   wire [ADDRESS_WIDTH-1:0]     wptr_bin_w;
   wire [ADDRESS_WIDTH-1:0]     rptr_bin_w;
   
   //READ DOMAIN    
   wire [ADDRESS_WIDTH-1:0]     rptr;
   reg [ADDRESS_WIDTH-1:0]      wptr_sync[1:0];
   wire                         read_en_int;
   wire [ADDRESS_WIDTH-1:0]     wptr_bin_r;
   wire [ADDRESS_WIDTH-1:0]     rptr_bin_r;

   //WRITE DOMAIN LOGIC

   //sync read pointer
   always @ (posedge wclk) begin 
      rptr_sync[0] <= rptr;
      rptr_sync[1] <= rptr_sync[0];
   end
   
   //effective write enable
   assign write_en_int = write_en & ~full;
   
   gray_counter #(.COUNTER_WIDTH(ADDRESS_WIDTH)) wptr_counter (
                                               .clk(wclk),
                                               .rst(rst), 
                                               .en(write_en_int),
                                               .data_out(wptr)
                                               );
   //compute binary pointer difference
   gray2bin #(
       .DATA_W(ADDRESS_WIDTH)
   ) gray2bin_wptr_w (
       .gr(wptr),
       .bin(wptr_bin_w)
   );
   gray2bin #(
       .DATA_W(ADDRESS_WIDTH)
   ) gray2bin_rptr_w (
       .gr(rptr_sync[1]),
       .bin(rptr_bin_w)
   );
   assign level_w = wptr_bin_w - rptr_bin_w;
   
   assign full = (level_w == (FIFO_DEPTH-1));

   
   //READ DOMAIN LOGIC

   //sync write pointer
   always @ (posedge rclk) begin 
      wptr_sync[0] <= wptr;
      wptr_sync[1] <= wptr_sync[0];
   end

   //effective read enable
   assign read_en_int  = read_en & ~empty;

   gray_counter #(.COUNTER_WIDTH(ADDRESS_WIDTH)) rptr_counter (
                                               .clk(rclk),
                                               .rst(rst), 
                                               .en(read_en_int),
                                               .data_out(rptr)
                                              );
   
   //compute binary pointer difference
   gray2bin #(
       .DATA_W(ADDRESS_WIDTH)
   ) gray2bin_wptr_r (
       .gr(wptr_sync[1]),
       .bin(wptr_bin_r)
   );
   gray2bin #(
       .DATA_W(ADDRESS_WIDTH)
   ) gray2bin_rptr_r (
       .gr(rptr),
       .bin(rptr_bin_r)
   );
   assign level_r = wptr_bin_r - rptr_bin_r;
   

   assign empty = (level_r == 0);

   iob_t2p_ram #(
            .DATA_W(DATA_WIDTH),
            .ADDR_W(ADDRESS_WIDTH)
            ) fifo_t2p_ram (
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
