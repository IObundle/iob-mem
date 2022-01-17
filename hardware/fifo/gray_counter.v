`timescale 1ns/1ps

module gray_counter 
  #(
    parameter   COUNTER_WIDTH = 4)
   (
    input wire                 rst,
    input wire                 clk,
    input wire                 en,
    output [COUNTER_WIDTH-1:0] data_out
    );
   
   reg [COUNTER_WIDTH-1:0]     bin_counter;
   reg [COUNTER_WIDTH-1:0]     gray_counter;

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
