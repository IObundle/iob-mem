`timescale 1ns / 1ps
`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}

//test defines
`define FIFO_ADDR_W 10

//comment to run W_NARROW_R_WIDE
`define W_WIDE_R_NARROW 1

`ifdef  W_WIDE_R_NARROW
 `define W_DATA_W 32
 `define R_DATA_W 8
`else
 `define W_NARROW_R_WIDE 1
 `define R_DATA_W 32
 `define W_DATA_W 8
`endif


module iob_async_fifo_asym_tb;

   localparam W_DATA_W = `W_DATA_W;
   localparam R_DATA_W = `R_DATA_W;
   
   localparam MINDATA_W = `min( W_DATA_W, R_DATA_W );
   localparam MAXDATA_W = `max(W_DATA_W, R_DATA_W);
   localparam L_ADDR_W = `FIFO_ADDR_W-$clog2(MAXDATA_W/MINDATA_W);//lower ADDR_W (higher DATA_W)
   localparam W_ADDR_W = (W_DATA_W == MAXDATA_W) ? L_ADDR_W : `FIFO_ADDR_W;
   localparam R_ADDR_W = (R_DATA_W == MAXDATA_W) ? L_ADDR_W : `FIFO_ADDR_W;
   
   reg reset = 0;
 
   //write port 
   reg                 w_clk = 0;
   reg                 w_en = 0;
   reg [W_DATA_W-1:0] w_data;
   wire                 w_full;
   wire [W_ADDR_W-1:0] w_level;
   
   //read port 
   reg r_clk = 0;
   reg r_en = 0;
   wire [R_DATA_W-1:0] r_data;
   wire                 r_empty;
   wire [R_ADDR_W-1:0] r_level;

   
   // clocks
   parameter clk_per_w = 10; //ns
   always #(clk_per_w/2) w_clk = ~w_clk;
   parameter clk_per_r = 13; //ns
   always #(clk_per_r/2) r_clk = ~r_clk;

   integer              i,j; //iterators

   reg [W_DATA_W*2**W_ADDR_W-1:0] test_data;
   reg [W_DATA_W*2**W_ADDR_W-1:0] read;

   localparam TESTSIZE = 256; //bytes
   
   
   initial begin //writer process

`ifdef W_WIDE_R_NARROW
      $display("W_WIDE_R_NARROW");
`else
      $display("W_NARROW_R_WIDE");
`endif
      $display("W_DATA_W=%d", W_DATA_W);
      $display("R_DATA_W=%d", R_DATA_W);

   
      //create the test data bytes
      for (i=0; i < TESTSIZE; i=i+1)
        test_data[i*8 +: 8] = i;    

      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif
      repeat(4) @(posedge w_clk) #1;


      //reset FIFO
      #clk_per_w;
      @(posedge w_clk) #1;
      reset = 1;
      @(posedge w_clk) #1;
      reset = 0;
      

      //pause for 1ms to allow the reader to test the empty flag
      #1000000 @(posedge w_clk) #1;
      
      
      //write test data to fifo
      for(i = 0; i < ((TESTSIZE*8)/W_ADDR_W); i = i + 1) begin
         if( i == ((TESTSIZE*8)/W_ADDR_W/2) ) //another pause
           #1000000 @(posedge w_clk) #1;

         if(!w_full) begin
            w_en = 1;
            w_data = test_data[i*W_ADDR_W +: W_ADDR_W];
            @(posedge w_clk) #1;
            w_en = 0;
         end
      end

      #(5*clk_per_r) $finish;

   end // end fo writer process
   
   initial begin //reader process

      //wait for reset to be de-asserted
      //read data from fifo
      for(j = 0; j < ((TESTSIZE*8)/R_ADDR_W); j = j + 1) begin
         if(!r_empty) begin
            r_en = 1;
            @(posedge w_clk) #1;
            read[j*R_ADDR_W +: R_ADDR_W] = r_data;
            r_en = 0;
         end
      end

      if(read != test_data)
        $display("ERROR: data read does not match the test data.");   
   end
      
   // Instantiate the Unit Under Test (UUT)
   iob_async_fifo_asym 
     #(
       .W_DATA_W(W_DATA_W),
       .R_DATA_W(R_DATA_W),
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
