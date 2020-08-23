`timescale 1ns / 1ps

`define NUM_COL 2
`define COL_WIDTH 4
`define DATA_W (`NUM_COL * `COL_WIDTH)
`define ADDR_W 4
`define hex_file1 "tb1.hex"
`define hex_file2 "tb2.hex"

module sp_ram_be_tb;
	
	//Inputs
	reg clk;
    reg en; // enable access to ram
    reg [`NUM_COL-1:0] we; // write enable vector
    reg [`ADDR_W-1:0] addr;
    reg [`DATA_W-1:0] data_in;
   	
   	//Ouptuts
   	reg [`DATA_W-1:0] data_out;

    // .hex file
    reg [7:0] filemem [0:15];

    integer i, a;

    parameter clk_per = 10; // clk period = 10 timeticks

    initial begin
        // optional VCD
        `ifdef VCD
      	   $dumpfile("sp_ram.vcd");
      	   $dumpvars();
        `endif

        //Initialize Inputs
        clk = 1;
        en = 0;
        for(i=0; i<`NUM_COL; i = i + 1)
            we[i] = 0;
        addr = 0;

        // store file for comparison
        #clk_per
        @(posedge clk) #1;
        $readmemh(`hex_file1, filemem);


        @(posedge clk) #1;
        en = 1;

        // read from file stored in RAM
        @(posedge clk) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addr = i;
            @(posedge clk) #1;
            if(filemem[i]!= data_out) begin
                $display("Test failed: read error in position %d, where tb1.hex=%h but data_out=%h", i, filemem[i], data_out);
                $finish;
            end
        end
        
        #clk_per

        $readmemh(`hex_file2, filemem);

        // write into RAM in all positions and read from it
        @(posedge clk) #1;

        for(i = 0; i < 16; i = i + 1) begin
            we[i] = 1;
            @(posedge clk) #1;
            addr = i;
            data_in = filemem[i];
            @(posedge clk) #1;
        end

        @(posedge clk) #1;
        for(i = 0; i < `NUM_COL; i = i + 1)
            we = 0;

        @(posedge clk) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addr = i;
            @(posedge clk) #1;
            if(filemem[i] != data_out) begin
                $display("Test failed: write error in position %d, where tb2.hex=%h but data_out=%h", i, filemem[i], data_out);
                $finish;
            end
        end

        // test if output is truly different
        // this supposes that both hex files are completely different, including spaces
        $readmemh(`hex_file1, filemem);
        for(i = 0; i < 16; i = i + 1) begin
            addr = i;
            @(posedge clk) #1;
            if(filemem[i] == data_out) begin
                if(filemem[i] != 10) begin // rule out EOL
                    $display("Test failed: read error in position %d, where tb1.hex and data_out are '%h' but should not be the same", i, data_out);
                    $finish;
                end
            end
        end

        @(posedge clk) #1;
        en = 0;

        #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
        #(5*clk_per) $finish;

    end

   	// Instantiate the Unit Under Test (UUT)
    iob_sp_ram_be #(
        .NUM_COL(`NUM_COL),
        .COL_WIDTH(`COL_WIDTH),
    	.DATA_WIDTH(`DATA_W), 
    	.ADDR_WIDTH(`ADDR_W),
    	.FILE(`hex_file1)
	) uut (
		.clk(clk), 
		.en(en),
        .we(we),
        .addr(addr),
        .din(data_in),
        .dout(data_out)
	);
    
    // system clock
	always #(clk_per/2) clk = ~clk; 

endmodule // sp_ram_tb
