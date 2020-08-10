`timescale 1ns / 1ps

`define T 10

`define DATA_W 8
`define ADDR_W 4


module iob_2p_mem_tb;

   // Inputs
   reg clk;


   //write signals
   reg w_port_en;
   reg w_en;
   reg [`DATA_W-1:0] data_in;
   reg [`ADDR_W-1:0] w_addr;


   //read signals   
   reg [`ADDR_W-1:0] r_addr;
   reg               r_port_en;
   wire [`DATA_W-1:0] data_out;
   

   integer            i=0;

   initial begin
      $dumpfile("2p_mem_tb.vcd");
      $dumpvars();

      clk = 1;
      w_port_en = 0; 
      w_en = 0;
      w_addr = 0;
      data_in = 0;

      r_port_en = 0;
      r_addr = 0;

      @(posedge clk) #1;
      w_port_en = 1; 
      w_en = 1;

      //Write all the locations of RAM 
      for(i=0; i < 16; i = i + 1) begin
	 data_in = i;
	 w_addr = i;
	 @(posedge clk) #1;
      end

      w_port_en = 0;
      w_en = 0; 	 
      r_port_en = 1; 
 
      //Read all the locations of RAM
      for(i=0; i < 16; i = i + 1) begin
         r_addr = i;
	 @(posedge clk) #1;
      end

      // Test
      for(i=0; i < 16; i = i + 1) begin
         if(data_in!=i) begin
           $display("Test failed on vector %d: %x / %x", i, data_in, i);
           $finish;
         end
      @(posedge clk) #1;
      end
      #(5*T)
      $display("Test completed sucessfully.")
      $finish;

   end

    // Instantiate the Unit Under Test (UUT)
    iob_2p_mem #(
    	.DATA_W(`DATA_W),
    	.ADDR_W(`ADDR_W),
    	.USE_RAM(0)
    )
     uut (
        .clk(clk), 
        .w_en(w_en), 
        .data_in(data_in), 
        .w_addr(w_addr), 
        .r_addr(r_addr),
        .w_port_en(w_port_en),
        .r_port_en(r_port_en),
        .data_out(data_out)
        );

   //Clock
   always #(T/2) clk = ~clk;

endmodule
