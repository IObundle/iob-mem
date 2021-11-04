`timescale 1ns / 1ps

`define NUM_COL 2
`define COL_WIDTH 4
`define DATA_WIDTH (`NUM_COL * `COL_WIDTH)
`define ADDR_WIDTH 4

module iob_reg_file_tb;
	
	//Inputs
	reg clk;
    reg rst;
    reg [`DATA_WIDTH-1:0] wdata;
    reg [`ADDR_WIDTH-1:0] addr;
    reg [`NUM_COL-1:0] en;
   	
   	//Ouptuts
   	reg [`DATA_WIDTH-1 :0] rdata;

    integer i;

    parameter clk_per = 10; // clk period = 10 timeticks

    initial begin
        // optional VCD
        `ifdef VCD
      	   $dumpfile("reg_file.vcd");
      	   $dumpvars();
        `endif
      	
        //Initialize Inputs
        clk = 1;
        rst = 0;
        wdata = 0;
        addr = 0;
        en = 0;

        #clk_per;
        @(posedge clk) #1; 
        rst = 1;
        @(posedge clk) #1;
        rst = 0;
        
        @(posedge clk) #1;
        en = 1;

        //Write and real all the locations
        for(i=0; i < 16; i = i + 1) begin
            addr = i;
            wdata = i;
            @(posedge clk) #1;
            if(rdata != i) begin
                $display("Test 1 failed: read error in rdata.\n \t i=%0d; data=%0d", i, rdata);
                $finish;
            end
            @(posedge clk) #1;
        end

        @(posedge clk) #1;
        en = 0;
        addr = 0;

        //Read all the locations and check if still stored
        for(i=0; i < 16; i = i + 1) begin
            addr = i;
            @(posedge clk) #1;
            if(rdata != i) begin
                $display("Test 2 failed: read error in rdata.\n \t i=%0d; data=%0d", i, rdata);
                $finish;
            end
            @(posedge clk) #1;
        end

        //Resets the entire memory
        @(posedge clk) #1; 
        rst = 1;
        @(posedge clk) #1;
        rst = 0;


        //Read all the locations and check if reset worked
        for(i=0; i < 16; i = i + 1) begin
            addr = i;
            @(posedge clk) #1;
            if(rdata != 0) begin
                $display("Test 3 failed: rdata is not null");
                $finish;
            end
            @(posedge clk) #1;
        end

        #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
        #(5*clk_per) $finish;

    end

   	// Instantiate the Unit Under Test (UUT)
    iob_reg_file #(
    	.NUM_COL(`NUM_COL), 
    	.COL_WIDTH(`COL_WIDTH),
    	.ADDR_WIDTH(`ADDR_WIDTH),
        .DATA_WIDTH(`DATA_WIDTH)
	) uut (
		.clk(clk), 
		.rst(rst),
        .wdata(wdata),
        .addr(addr),
        .en(en),
        .rdata(rdata)
	);
    
    // system clock
	always #(clk_per/2) clk = ~clk; 

endmodule // iob_reg_file_tb
