`timescale 1ns / 1ps

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

      r_addr = 0; 
      r_port_en = 0;
      #20;

      //Write all the locations of RAM 
      for(i=0; i < 16; i = i + 1) begin
         @(posedge clk) w_port_en = 1; 
         w_en = 1;
	 data_in = i;
	 w_addr = i;
	 #10;
      end

      @(posedge clk)   w_port_en = 0;
      w_en = 0; 	 
      
      //Read all the locations of RAM
      for(i=0; i < 16; i = i + 1) begin
         @(posedge clk) r_port_en = 1; 
         r_addr = i;
	 #10;
      end

      #50$finish;

   end
    
   // Instantiate the Unit Under Test (UUT)
   iob_2p_mem #(
    	        .DATA_W(`DATA_W),
    	        .ADDR_W(`ADDR_W)
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
   always #5 clk = ~clk;

endmodule
