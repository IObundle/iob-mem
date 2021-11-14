`timescale 1ns / 1ps

`define DATA_W 8
`define ADDR_W 4
`define hex_file "tb1.hex"

module tdp_rom_tb;
   
   //Inputs
   reg clk_a;
   reg clk_b;
   reg r_en_a;
   reg [`ADDR_W-1:0] addr_a;
   reg 		     r_en_b;
   reg [`ADDR_W-1:0] addr_b;
   
   //Ouptuts
   reg [`DATA_W-1:0] r_data_a;
   reg [`DATA_W-1:0] r_data_b;
   
   // .hex file
   reg [7:0] 	     filemem [0:15];

   integer 	     i;

   parameter clk_per = 10; // clk period = 10 timeticks
   

   initial begin
      // optional VCD
`ifdef VCD
      $dumpfile("sp_rom.vcd");
      $dumpvars();
`endif
      
      //Initialize Inputs
      clk_a = 1;
      clk_b = 1;
      r_en_a = 0;
      addr_a = 0;
      r_en_b = 0;
      addr_b = 0;

      // store file for comparison
      #clk_per
      @(posedge clk_a) #1;
      @(posedge clk_b) #1;
      $readmemh(`hex_file, filemem);


      @(posedge clk_a) #1;
      r_en_a = 1;
      r_en_b = 1;

      @(posedge clk_a) #1;
      for(i = 0; i < 16; i = i + 1) begin
         addr_a = i;
	 addr_b = 15-i;
         @(posedge clk_a) #1;
         if(filemem[i]!=r_data_a) begin
            $display("Port A - Test failed: read error in position %d, where tb.hex=%h but r_data=%h", i, filemem[i], r_data_a);
            $finish;
         end
	 if (filemem[15-i]!= r_data_b) begin
	    $display("Port B - Test failed: read error in position %d, where tb.hex=%h but r_data=%h", i, filemem[i], r_data_b);
	    $finish;
	 end
      end

      @(posedge clk_b) #1;
      r_en_a = 0;
      r_en_b = 0;
      
      #clk_per
        $display("%c[1;34m",27);
      $display("Test completed successfully.");
      $display("%c[0m",27);
      #(5*clk_per) $finish;

   end

   // Instantiate the Unit Under Test (UUT)
   iob_tdp_rom #(
    	    .DATA_W(`DATA_W), 
    	    .ADDR_W(`ADDR_W),
    	    .MEM_INIT_FILE(`hex_file)
	    ) uut (
		   .clk_a(clk_a),
		   .clk_b(clk_b),
		   .r_en_a(r_en_a),
		   .r_en_b(r_en_b),
		   .addr_a(addr_a),
		   .addr_b(addr_b),
		   .r_data_a(r_data_a),
		   .r_data_b(r_data_b)
		   );
   
   // system clock
   always #(clk_per/2) clk_a = ~clk_a;
   always #(clk_per/2) clk_b = ~clk_b;

endmodule // sp_rom_tb
