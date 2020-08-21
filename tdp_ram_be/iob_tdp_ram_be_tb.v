`timescale 1ns / 1ps

`define NUM_COL 2
`define COL_WIDTH 4
`define DATA_W (`NUM_COL * `COL_WIDTH)
`define ADDR_W 4
`define hex_file1 "tb1.hex"
`define hex_file2 "tb2.hex"

module iob_tdp_ram_be_tb;

	//Inputs
	reg clkA;
    reg enaA; // enable access to ram
    reg [`NUM_COL-1:0] weA; // write enable vector
    reg [`ADDR_W-1:0] addrA;
    reg [`DATA_W-1:0] data_inA;

    reg clkB;
    reg enaB; // enable access to ram
    reg [`NUM_COL-1:0] weB; // write enable vector
    reg [`ADDR_W-1:0] addrB;
    reg [`DATA_W-1:0] data_inB;
   	
   	//Ouptuts
   	reg [`DATA_W-1:0] data_outA;
    reg [`DATA_W-1:0] data_outB;

    // .hex file
    reg [7:0] filemem [0:15];

    integer i, a;

    parameter clk_per = 10; // clk period = 10 timeticks

    initial begin
        // optional VCD
        `ifdef VCD
      	   $dumpfile("td_ram_be.vcd");
      	   $dumpvars();
        `endif

        //Initialize Inputs
        clkA = 1;
        clkB = 1;
        enaA = 0;
        enaB = 0;
        for(i=0; i<`NUM_COL; i = i + 1) begin
            weA[i] = 0;
            weB[i] = 0;
        end
        addrA = 0;
        addrB = 0;

        // store file for comparison
        #clk_per
        @(posedge clkA) #1;
        @(posedge clkB) #1;
        $readmemh(`hex_file1, filemem);


        @(posedge clkA) #1;
        enaA = 1;

        // read from file stored in RAM port A
        @(posedge clkA) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addrA = i;
            @(posedge clkA) #1;
            if(filemem[i]!= data_outA) begin
                $display("Test failed: read error in port A position %d, where tb1.hex=%h but data_outA=%h", i, filemem[i], data_outA);
                $finish;
            end
        end
        
        #clk_per

        @(posedge clkB) #1;
        enaB = 1;

        // read from file stored in RAM port B
        @(posedge clkB) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addrB = i;
            @(posedge clkB) #1;
            if(filemem[i]!= data_outB) begin
                $display("Test failed: read error in port B position %d, where tb1.hex=%h but data_outB=%h", i, filemem[i], data_outB);
                $finish;
            end
        end
        
        #clk_per

        $readmemh(`hex_file2, filemem);

        // write into RAM port A in all positions and read from it
        @(posedge clkA) #1;

        for(i = 0; i < 16; i = i + 1) begin
            weA[i] = 1;
            @(posedge clkA) #1;
            addrA = i;
            data_inA = filemem[i];
            @(posedge clkA) #1;
        end

        @(posedge clkA) #1;
        for(i = 0; i < `NUM_COL; i = i + 1)
            weA[i] = 0;

        @(posedge clkA) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addrA = i;
            @(posedge clkA) #1;
            if(filemem[i] != data_outA) begin
                $display("Test failed: write error in port A position %d, where tb2.hex=%h but data_outA=%h", i, filemem[i], data_outA);
                $finish;
            end
        end

        // write into RAM port B in all positions and read from it
        @(posedge clkB) #1;

        for(i = 0; i < 16; i = i + 1) begin
            weB[i] = 1;
            @(posedge clkB) #1;
            addrB = i;
            data_inB = filemem[i];
            @(posedge clkB) #1;
        end

        @(posedge clkB) #1;
        for(i = 0; i < `NUM_COL; i = i + 1)
            weB[i] = 0;

        @(posedge clkB) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addrB = i;
            @(posedge clkB) #1;
            if(filemem[i] != data_outB) begin
                $display("Test failed: write error in port B position %d, where tb2.hex=%h but data_outB=%h", i, filemem[i], data_outB);
                $finish;
            end
        end

        // test if output is truly different
        // this supposes that both hex files are completely different, including spaces
        $readmemh(`hex_file1, filemem);
        // port A
        for(i = 0; i < 16; i = i + 1) begin
            addrA = i;
            @(posedge clkA) #1;
            if(filemem[i] == data_outA) begin
                if(filemem[i] != 10) begin // rule out EOL
                    $display("Test failed: read error in port A position %d, where tb1.hex and data_outA are '%h' but should not be the same", i, data_outA);
                    $finish;
                end
            end
        end

        @(posedge clkA) #1;
        enaA = 0;

        // port B
        for(i = 0; i < 16; i = i + 1) begin
            addrB = i;
            @(posedge clkB) #1;
            if(filemem[i] == data_outB) begin
                if(filemem[i] != 10) begin // rule out EOL
                    $display("Test failed: read error in port B position %d, where tb1.hex and data_outB are '%h' but should not be the same", i, data_outB);
                    $finish;
                end
            end
        end

        @(posedge clkB) #1;
        enaB = 0;

        #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
        #(5*clk_per) $finish;

    end

   	// Instantiate the Unit Under Test (UUT)
    iob_tdp_ram_be #(
        .NUM_COL(`NUM_COL),
        .COL_WIDTH(`COL_WIDTH),
    	.DATA_WIDTH(`DATA_W), 
    	.ADDR_WIDTH(`ADDR_W),
    	.FILE(`hex_file1)
	) uut (
		.clkA(clkA), 
		.enaA(enaA),
        .weA(weA),
        .addrA(addrA),
        .dinA(data_inA),
        .doutA(data_outA),
        .clkB(clkB), 
        .enaB(enaB),
        .weB(weB),
        .addrB(addrB),
        .dinB(data_inB),
        .doutB(data_outB)
	);
    
    // system clock
	always #(clk_per/2) clkA = ~clkA; 
    always #(clk_per/2) clkB = ~clkB; 

endmodule // iob_tdp_ram_be_tb
