`timescale 1ns / 1ps

`define DATA_W 8
`define ADDR_W 4

`ifdef WR_RATIO
 `define W_DATA_W (`DATA_W*`WR_RATIO)
 `define R_DATA_W (`DATA_W)
 `define FIFO_ADDR_W (`ADDR_W+$clog2(`WR_RATIO))

// TB defines
 `define W_ADDR_W (`ADDR_W)
 `define R_ADDR_W (`FIFO_ADDR_W)
`endif

`ifdef RW_RATIO
 `define W_DATA_W (`DATA_W)
 `define FIFO_ADDR_W (`ADDR_W+$clog2(`RW_RATIO))
 `define R_DATA_W (`DATA_W*`RW_RATIO)

// TB defines
 `define R_ADDR_W (`ADDR_W)
 `define W_ADDR_W (`FIFO_ADDR_W)

`endif

// `define R_RATIO (`W_DATA_W/`R_DATA_W)

module iob_async_fifo_asym_tb;
   
   //Inputs
   reg reset;
   reg r_en;
   reg r_clk;
   reg [`W_DATA_W-1:0] w_data;
   reg                 w_en;
   reg                 w_clk;
   
   //Outputs
   reg [`R_DATA_W-1:0] r_data;
   wire                r_empty;
   wire [`R_ADDR_W-1:0] r_level;
   wire                 w_full;
   wire [`W_ADDR_W-1:0] w_level;

   integer              i;
   
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

`ifdef WR_RATIO      
      $display("Asymmetric Asynchronous FIFO testbench.\n\tWR_RATIO=%0d", `WR_RATIO);
`else
      $display("Asymmetric Asynchronous FIFO testbench.\n\tRW_RATIO=%0d", `RW_RATIO);
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
      for(i=0; i < 2**`W_ADDR_W-1; i = i + 1) begin
         if(w_level !=i ) begin
            $display("Test failed: write error in w_data.\n \t i=%0d; data=%0d; w_level=%0d", i, w_data, w_level);
            $finish;
         end
`ifdef WR_RATIO
	 w_data = i;
`else // RW_RATIO
         w_data = i/`RW_RATIO*((i%`RW_RATIO)==0);
`endif
         @(posedge w_clk) #1;
      end
      
      @(posedge w_clk) #1;
      w_en = 0; //Fifo is now full
      if(w_full!=1 || w_level!=2**`W_ADDR_W-1) begin
         $display("Test failed: fifo not full.");
         $finish;
      end
      
      #clk_per_r @(posedge r_clk) #1;
      r_en=1;

`ifdef WR_RATIO
      //Read all locations of RAM.
      for(i=0; i < `WR_RATIO*((2**`W_ADDR_W)-1); i = i + 1) begin
         // Result will only be available in the next cycle
         @(posedge r_clk) #1;
	 if(r_data != i/`WR_RATIO*((i%`WR_RATIO)==0) || r_level != (((2**`W_ADDR_W)-1)*`WR_RATIO)-1-i) begin
            $display("Test failed: read error in r_data.\n \t i=%0d; data=%0d; exp=%0d; lvl=%0d, levl=%0d", i, r_data, i/`WR_RATIO*((i%`WR_RATIO)==0), (((2**`W_ADDR_W)-1)*`WR_RATIO)-i, r_level);
            // $finish;
         end
      end
`else // RW_RATIO
      //Read all the locations of RAM.
      for(i=0; i < ((2**`W_ADDR_W)/`RW_RATIO)-1; i = i + 1) begin
         // Result will only be available in the next cycle
         @(posedge r_clk) #1;
	 if(r_data != i || r_level != ((2**`R_ADDR_W)-2)-i) begin
            $display("Test failed: read error in r_data.\n \t i=%0d; data=%0d", i, r_data);
            // $finish;
         end
      end
`endif

      @(posedge r_clk) #1;
      r_en = 0; //Fifo is now empty
      @(posedge r_clk) #1;
      if(r_empty!=1 || r_level!=0) begin
         $display("Test failed: fifo not empty.\n \t");
         $finish;
      end

      #(5*clk_per_r) $finish;

   end

   // Instantiate the Unit Under Test (UUT)
   iob_async_fifo_asym 
     #(
       .W_DATA_W(`W_DATA_W),
       .R_DATA_W(`R_DATA_W),
       .ADDR_W(`FIFO_ADDR_W)
       ) 
   uut 
     (
      .rst(reset),
      
      .r_clk(r_clk),
      .r_en(r_en),
      .r_data(r_data),
      .r_empty(r_empty),
      .r_level(r_level),

      .w_clk(w_clk),
      .w_en(w_en),
      .w_data(w_data),
      .w_full(w_full),
      .w_level(w_level)
      );
   
endmodule // iob_asyn_fifo_asym_tb
