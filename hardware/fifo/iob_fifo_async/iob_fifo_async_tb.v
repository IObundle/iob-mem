`timescale 1ns / 1ps

`define DATA_W 8
`define ADDR_W 4
`define TESTSIZE 256 // test size in bytes

module iob_fifo_async_tb;

   localparam DATA_W = `DATA_W;
   localparam ADDR_W = `ADDR_W;
   localparam TESTSIZE = `TESTSIZE;

   // Inputs
   reg rst;
   reg r_en;
   reg r_clk = 0;
   reg [DATA_W-1:0] w_data;
   reg              w_en;
   reg              w_clk = 1;

   // Outputs
   reg [DATA_W-1:0] r_data;
   wire             r_empty;
   wire [ADDR_W-1:0] r_level;
   wire              w_full;
   wire [ADDR_W-1:0] w_level;

   integer           i, j;

   reg [DATA_W*2**ADDR_W-1:0] test_input;
   reg [DATA_W*2**ADDR_W-1:0] test_output;

   // Clocks
   parameter clk_per_w = 10; //ns
   always #(clk_per_w/2) w_clk = ~w_clk;
   parameter clk_per_r = 13; //ns
   always #(clk_per_r/2) r_clk = ~r_clk;

   initial begin // Writer process

      // Initialize Inputs
      w_en = 0;
      w_data = 0;

      $display("DATA_W = %.0f", DATA_W);
      $display("ADDR_W = %.0f", ADDR_W);

      // Create the test data bytes
      for(i=0; i < TESTSIZE; i=i+1) begin
         test_input[i*8 +: 8] = i;
      end

      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif
      repeat(4) @(posedge w_clk) #1;

      // Write all the locations of FIFO
      #clk_per_w;
      @(posedge w_clk) #1;
      rst = 1;
      @(posedge w_clk) #1;
      rst = 0;

      // Pause for 1ms to allow the reader to test the empty flag
      #1000000 @(posedge w_clk) #1;

      // Write test input to fifo
      for(i=0; i < ((TESTSIZE*8)/DATA_W); i=i+1) begin
         if(i == ((TESTSIZE*8)/DATA_W/2)) begin // Another pause
            #1000000 @(posedge w_clk) #1;
         end

         if(~w_full) begin
            w_en = 1;
            w_data = test_input[i*DATA_W +: DATA_W];
            @(posedge w_clk) #1;
            w_en = 0;
         end
         @(posedge w_clk) #1;
      end

      #(5*clk_per_r) $finish;
   end  // end of Writer process

   initial begin // Read process

      // initialize values
      r_en = 0;

      @(negedge rst) repeat(4) @(posedge r_clk) #1;

      // Read data from fifo
      for(j=0; j < ((TESTSIZE*8)/DATA_W); j=j+1) begin
         // Wait for data to read
         while(r_empty) begin
            @(posedge r_clk) #1;
         end

         if(~r_empty) begin
            r_en = 1;
            @(posedge r_clk) #1;
            test_output[j*DATA_W +: DATA_W] = r_data;
            r_en = 0;
         end
      end

      // Compare written and read data
      if(test_output !== test_input)
        $display("ERROR: data read does not match the test data.");
   end // end of Read process

   // Instantiate the Unit Under Test (UUT)
   iob_fifo_async
     #(
       .DATA_W(DATA_W),
       .ADDR_W(ADDR_W)
       )
   uut
     (
      .rst(rst),

      .w_clk(w_clk),
      .w_en(w_en),
      .w_data(w_data),
      .w_full(w_full),
      .w_level(w_level),

      .r_clk(r_clk),
      .r_en(r_en),
      .r_data(r_data),
      .r_empty(r_empty),
      .r_level(r_level)
      );

endmodule
