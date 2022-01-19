`timescale 1ns / 1ps

`define DATA_W 8
`define ADDR_W 4

module iob_async_fifo_tb;
   
   //Inputs
   reg reset;
   reg r_en;
   bit r_clk;
   reg [`DATA_W-1:0] w_data;
   reg w_en;
   bit w_clk;
     
   //Outputs
   reg [`DATA_W-1:0] r_data;
   wire r_empty;
   wire [`ADDR_W-1:0] r_level;
   wire w_full;
   wire [`ADDR_W-1:0] w_level;

   integer i;

   // clocks
   parameter clk_per_w = 10; //ns
   always #(clk_per_w/2) w_clk = ~w_clk;
   parameter clk_per_r = 13; //ns
   always #(clk_per_r/2) r_clk = ~r_clk;



   initial begin
       // optional VCD
       `ifdef VCD
            $dumpfile("uut.vcd");
            $dumpvars();
       `endif
         
       //Initialize Inputs
       r_clk = 0;
       w_clk = 1;
       reset = 0;
       w_data = 0;
       r_en = 0;
       w_en = 0;

       //Write all the locations of FIFO
       #clk_per_w;
       @(posedge w_clk) #1;
       reset = 1;
       @(posedge w_clk) #1;
       reset = 0;
       
       @(posedge w_clk) #1;
       w_en = 1;
       for(i=0; i < 15; i = i + 1) begin
           if(w_level !=i ) begin
               $display("Test failed: write error in w_data.\n \t i=%0d; data=%0d; w_level=%0d", i, w_data, w_level);
               $finish;
           end
           w_data = i;
           @(posedge w_clk) #1;
       end
     
       @(posedge w_clk) #1;
       w_en = 0; //Fifo is now w_full
       if(w_full!=1 || w_level!=15) begin
           $display("Test failed: fifo not w_full.");
           $finish;
       end
       
       #clk_per_r
       @(posedge r_clk) #1;
       r_en=1;
       //Read all the locations of RAM.
       for(i=0; i < 15; i = i + 1) begin
           // Result will only be available in the next cycle
           @(posedge r_clk) #1;
           if(r_data != i || r_level != 14-i) begin
               $display("Test failed: read error in r_data.\n \t i=%0d; data=%0d", i, r_data);
               $finish;
           end
       end

       @(posedge r_clk) #1;
       r_en = 0; //Fifo is now empty
       @(posedge r_clk) #1;
       if(r_empty!=1 || r_level!=0) begin
           $display("Test failed: fifo not empty.\n \t");
           $finish;
       end

       #clk_per_r
        $display("%c[1;34m",27);
        $display("%c[0m",27);
       #(5*clk_per_r) $finish;

   end

      // Instantiate the Unit Under Test (UUT)
   iob_async_fifo #(
       .DATA_WIDTH(`DATA_W),
       .ADDRESS_WIDTH(`ADDR_W)
   ) uut (
       .rst(reset),

       .w_en(w_en),
       .w_clk(w_clk),
       .w_data(w_data),
       .w_full(w_full),
       .w_level(w_level),

       .r_en(r_en),
       .r_clk(r_clk),
       .r_data(r_data),
       .r_empty(r_empty),
       .r_level(r_level)
   );
   
endmodule // iob_async_fifo_tb
