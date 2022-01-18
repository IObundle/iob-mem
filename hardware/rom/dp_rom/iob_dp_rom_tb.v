`timescale 1ns / 1ps

`define FILE "data.hex"

module dp_rom_tb;

   // Inputs
   reg clk;
   reg r_en_a;
   reg [`ADDR_W-1:0] addr_a;
   reg               r_en_b;
   reg [`ADDR_W-1:0] addr_b;
   
   // Ouptuts
   reg [`DATA_W-1:0] r_data_a;
   reg [`DATA_W-1:0] r_data_b;
   
   // .hex file
   reg [`DATA_W-1:0] filemem [0:2**`ADDR_W-1];

   integer           i;

   parameter clk_per = 10; // clk period = 10 timeticks
   

   initial begin
      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif
      
      // Initialize Inputs
      clk = 1;
      r_en_a = 0;
      addr_a = 0;
      r_en_b = 0;
      addr_b = 0;

      #clk_per;
      @(posedge clk) #1;
      $readmemh(`FILE, filemem);

      @(posedge clk) #1;
      r_en_a = 1;
      r_en_b = 1;

      @(posedge clk) #1;
      for(i = 0; i < 2**`ADDR_W; i = i + 1) begin
         addr_a = i;
         addr_b = 2**`ADDR_W-1-i;
         @(posedge clk) #1;
         if(filemem[i] != r_data_a) begin
            $display("Port A - Test failed: read error in position %d, where tb.hex=%h but r_data=%h", i, filemem[i], r_data_a);
            $finish;
         end
         if (filemem[2**`ADDR_W-1-i] != r_data_b) begin
            $display("Port B - Test failed: read error in position %d, where tb.hex=%h but r_data=%h", i, filemem[2**`ADDR_W-1-i], r_data_b);
            $finish;
         end
      end

      @(posedge clk) #1;
      r_en_a = 0;
      r_en_b = 0;
      
      #clk_per;
      $display("%c[1;34m",27);
      $display("Test completed successfully.");
      $display("%c[0m",27);
      #(5*clk_per) $finish;

   end

   // Instantiate the Unit Under Test (UUT)
   iob_dp_rom
     #(
       .DATA_W(`DATA_W),
       .ADDR_W(`ADDR_W),
       .FILE(`FILE)
       )
   uut
     (
      .clk(clk),

      .r_en_a(r_en_a),
      .addr_a(addr_a),
      .r_data_a(r_data_a),

      .r_en_b(r_en_b),
      .addr_b(addr_b),
      .r_data_b(r_data_b)
      );

   // system clock
   always #(clk_per/2) clk = ~clk; 

endmodule
