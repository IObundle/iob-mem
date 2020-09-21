`timescale 1ns / 1ps
 
`define DATA_W 8
`define ADDR_W 4

// `define RW_RATIO 4
// `define WR_RATIO 4
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


module afifo_assim_tb;
   
   //Inputs
   reg reset;
   reg read;
   bit rclk;
   reg [`W_DATA_W-1:0] data_in;
   reg write;
   bit wclk;
     
   //Outputs
   reg [`R_DATA_W-1:0] data_out;
   wire empty_out;
   wire [`R_ADDR_W-1:0] level_r;
   wire full_out;
   wire [`W_ADDR_W-1:0] level_w;

   integer i;

   parameter clk_per = 10; // clk period = 10 timeticks
   

   initial begin
       // optional VCD
       `ifdef VCD
            $dumpfile("afifo.vcd");
            $dumpvars();
       `endif

        $display("%c[1;34m",27);
`ifdef WR_RATIO      
      $display("Assimetric Asynchronout Fifo testbench.\n\tWR_RATIO=%0d", `WR_RATIO);
`else
      $display("Assimetric Asynchronout Fifo testbench.\n\tRW_RATIO=%0d", `RW_RATIO);
`endif
      $display("%c[0m",27);

       //Initialize Inputs
       rclk = 0;
       wclk = 1;
       reset = 0;
       data_in = 0;
       read = 0;
       write = 0;

       //Write all the locations of FIFO
       #clk_per;
       @(posedge wclk) #1;
       reset = 1;
       @(posedge wclk) #1;
       reset = 0;
       
       @(posedge wclk) #1;
       write = 1;
       for(i=0; i < 2**`W_ADDR_W-1; i = i + 1) begin
           if(level_w !=i ) begin
               $display("Test failed: write error in data_in.\n \t i=%0d; data=%0d; level_w=%0d", i, data_in, level_w);
               $finish;
           end
       `ifdef WR_RATIO
	  data_in = i;
	  `else // RW_RATIO
           data_in = i/`RW_RATIO*((i%`RW_RATIO)==0);
	  `endif
           @(posedge wclk) #1;
       end
     
       @(posedge wclk) #1;
       write = 0; //Fifo is now full
       if(full_out!=1 || level_w!=2**`W_ADDR_W-1) begin
           $display("Test failed: fifo not full.");
           $finish;
       end
       
       #clk_per
       @(posedge rclk) #1;
       read=1;
`ifdef WR_RATIO
       //Read all the locations of RAM.
       for(i=0; i < `WR_RATIO*((2**`W_ADDR_W)-1); i = i + 1) begin
           // Result will only be available in the next cycle
           @(posedge rclk) #1;
	  if(data_out != i/`WR_RATIO*((i%`WR_RATIO)==0) || level_r != (((2**`W_ADDR_W)-1)*`WR_RATIO)-1-i) begin
               $display("Test failed: read error in data_out.\n \t i=%0d; data=%0d; exp=%0d; lvl=%0d, levl=%0d", i, data_out, i/`WR_RATIO*((i%`WR_RATIO)==0), (((2**`W_ADDR_W)-1)*`WR_RATIO)-i, level_r);
               // $finish;
           end
       end
`else // RW_RATIO
      //Read all the locations of RAM.
       for(i=0; i < ((2**`W_ADDR_W)/`RW_RATIO)-1; i = i + 1) begin
           // Result will only be available in the next cycle
           @(posedge rclk) #1;
	  if(data_out != i || level_r != ((2**`R_ADDR_W)-2)-i) begin
               $display("Test failed: read error in data_out.\n \t i=%0d; data=%0d", i, data_out);
               // $finish;
           end
       end
`endif
       @(posedge rclk) #1;
       read = 0; //Fifo is now empty
       @(posedge rclk) #1;
       if(empty_out!=1 || level_r!=0) begin
           $display("Test failed: fifo not empty.\n \t");
           $finish;
       end

       #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
       #(5*clk_per) $finish;

   end

      // Instantiate the Unit Under Test (UUT)
   iob_afifo_assim #(
		    .W_DATA_W(`W_DATA_W),
		    .R_DATA_W(`R_DATA_W),
		    .ADDR_W(`FIFO_ADDR_W)
   ) uut (
       .rst(reset),
       .data_out(data_out),
       .empty(empty_out),
       .level_r(level_r),
       .read_en(read),
       .rclk(rclk),
       .data_in(data_in),
       .full(full_out),
       .level_w(level_w),
       .write_en(write),
       .wclk(wclk)
   );
   
   // system clock
   always #(clk_per/2) wclk = ~wclk;
   always #(clk_per/2) rclk = ~rclk;

endmodule // afifo_tb
