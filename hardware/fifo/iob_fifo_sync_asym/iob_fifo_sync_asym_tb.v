`timescale 1ns / 1ps
`include "iob_lib.vh"

//test defines
`define W_DATA_W 32
`define R_DATA_W 8
`define ADDR_W 10
`define TESTSIZE 256


module iob_fifo_sync_asym_tb;

   localparam TESTSIZE = `TESTSIZE; //bytes
   localparam W_DATA_W = `W_DATA_W;
   localparam R_DATA_W = `R_DATA_W;
   localparam MAXDATA_W = `max(W_DATA_W, R_DATA_W);
   localparam MINDATA_W = `min( W_DATA_W, R_DATA_W );
   localparam ADDR_W = `ADDR_W;   
   localparam MINADDR_W = ADDR_W-$clog2(MAXDATA_W/MINDATA_W);//lower ADDR_W (higher DATA_W)
   localparam W_ADDR_W = W_DATA_W == MAXDATA_W? MINADDR_W : ADDR_W;
   localparam R_ADDR_W = R_DATA_W == MAXDATA_W? MINADDR_W : ADDR_W;
   
   reg reset = 0;
   reg                 clk = 0;
 
   //write port 
   reg                 w_en = 0;
   reg [W_DATA_W-1:0]  w_data;
   wire                w_full;
   wire [W_ADDR_W-1:0] w_level;
   
   //read port 
   reg                 r_en = 0;
   wire [R_DATA_W-1:0] r_data;
   wire                r_empty;
   wire [R_ADDR_W-1:0] r_level;

   parameter clk_per = 10; // clk period = 10 timeticks
   always
     #(clk_per/2) clk = ~clk; 

   integer             i,j; //iterators

   reg [W_DATA_W*2**W_ADDR_W-1:0] test_data;
   reg [W_DATA_W*2**W_ADDR_W-1:0] read;

   initial begin //writer process

      if(W_DATA_W > R_DATA_W)
        $display("W_DATA_W > R_DATA_W");
      else if (W_DATA_W < R_DATA_W)
        $display("W_DATA_W < R_DATA_W");
      else
        $display("W_DATA_W = R_DATA_W");

      $display("W_DATA_W=%d", W_DATA_W);
      $display("R_DATA_W=%d", R_DATA_W);
      $display("ADDR_W=%d", ADDR_W);

      //create the test data bytes
      for (i=0; i < TESTSIZE; i=i+1)
        test_data[i*8 +: 8] = i;    

      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif
      repeat(4) @(posedge clk) #1;


      //reset FIFO
      #clk_per;
      @(posedge clk) #1;
      reset = 1;
      @(posedge clk) #1;
      reset = 0;
      

      //pause for 1ms to allow the reader to test the empty flag
      #1000000 @(posedge clk) #1;
      
      
      //write test data to fifo
      for(i = 0; i < ((TESTSIZE*8)/W_ADDR_W); i = i + 1) begin
         if( i == ((TESTSIZE*8)/W_ADDR_W/2) ) //another pause
           #1000000 @(posedge clk) #1;

         if(!w_full) begin
            w_en = 1;
            w_data = test_data[i*W_ADDR_W +: W_ADDR_W];
            @(posedge clk) #1;
            w_en = 0;
         end
      end

      #(5*clk_per) $finish;

   end // end of writer process
   
   initial begin //reader process

      //wait for reset to be de-asserted
      @(negedge reset) repeat(4) @(posedge clk) #1;

      //read data from fifo
      for(j = 0; j < ((TESTSIZE*8)/R_ADDR_W); j = j + 1) begin
         if(!r_empty) begin
            r_en = 1;
            @(posedge clk) #1;
            read[j*R_ADDR_W +: R_ADDR_W] = r_data;
            r_en = 0;
         end
      end

      if(read != test_data)
        $display("ERROR: data read does not match the test data.");   
   end
      
   // Instantiate the Unit Under Test (UUT)
   iob_fifo_sync_asym 
     #(
       .W_DATA_W(W_DATA_W),
       .R_DATA_W(R_DATA_W),
       .ADDR_W(ADDR_W)
       ) 
   uut 
     (
      .rst(reset),
      .clk(clk),

      .r_en(r_en),
      .r_data(r_data),
      .r_empty(r_empty),
      .r_level(r_level),

      .w_en(w_en),
      .w_data(w_data),
      .w_full(w_full),
      .w_level(w_level)
      );

endmodule // iob_sync_fifo_asym_tb
