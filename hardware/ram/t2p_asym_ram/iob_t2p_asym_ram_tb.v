`timescale 1ns / 1ps

module iob_t2p_asym_ram_tb;

   // uut inputs
   //write port 
   reg w_clk = 0;
   reg w_en = 0;
   reg [`W_DATA_W-1:0] w_data;
   reg [`W_ADDR_W-1:0] w_addr;
   //read port
   reg r_clk = 0;
   reg r_en = 0;
   wire [`R_DATA_W-1:0] r_data;
   reg [`R_ADDR_W-1:0]  r_addr;

    // instantiate the Unit Under Test (UUT)
    iob_t2p_asym_ram #(
        .W_DATA_W(`W_DATA_W),
        .W_ADDR_W(`W_ADDR_W),
        .R_DATA_W(`R_DATA_W),
        .R_ADDR_W(`R_ADDR_W)
    )
    uut (
        .w_clk(w_clk), 
        .w_en(w_en),
        .w_addr(w_addr),
        .w_data(w_data), 

	.r_clk(r_clk),
        .r_en(r_en), 
        .r_addr(r_addr),
        .r_data(r_data)
    );

    // system clock
   localparam clk_per_w = 10; //ns
   always #(clk_per_w/2) w_clk = ~w_clk; 

   localparam clk_per_r = 13; //ns
   always #(clk_per_r/2) r_clk = ~r_clk;
   
   localparam seq_ini = 10;
   integer              i;

   reg [`W_DATA_W*2**`W_ADDR_W-1:0] expected;
   reg [`R_DATA_W-1:0]              r_data_expected;

   initial begin
 
`ifdef W_WIDE_R_NARROW
      $display("W_WIDE_R_NARROW");
`else
      $display("W_NARROW_R_WIDE");
`endif
      $display("W_DATA_W=%d", `W_DATA_W);
      $display("W_ADDR_W=%d", `W_ADDR_W);      
      $display("R_DATA_W=%d", `R_DATA_W);
      $display("R_ADDR_W=%d", `R_ADDR_W);
   
      //compute expected response
      for (i=0; i < 2**`W_ADDR_W; i=i+1)
        expected[i*`W_DATA_W +: `W_DATA_W] = i+seq_ini;    
      
      // optional VCD
`ifdef VCD
      $dumpfile("uut.vcd");
      $dumpvars();
`endif
      repeat(4) @(posedge w_clk) #1;

      //write all the locations of RAM 
      w_en = 1; 
      for(i = 0; i < 2**`W_ADDR_W; i = i + 1) begin
         w_addr = i;
         w_data = i+seq_ini;
         @(posedge w_clk) #1;
      end
      w_en = 0;

      @(posedge r_clk) #1;

      //read all the locations of RAM
      r_en = 1;
      for(i = 0 ; i < 2**`R_ADDR_W; i = i + 1) begin
         r_addr = i;
         @(posedge r_clk) #1;
         //verify response
         r_data_expected = expected[i*`R_DATA_W +: `R_DATA_W];
         if(r_data != r_data_expected)
           $display("read addr=%x, got %x, expected %x", r_addr, r_data, r_data_expected);
      end
   
        #(5*clk_per_w) $finish;
    end

endmodule
