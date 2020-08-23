`timescale 1ns / 1ps

`define DATA_W 8
`define ADDR_W 4

`ifndef USE_RAM
    `define USE_RAM 0
`endif

module sfifo_tb;
	
	//Inputs
	reg clk;
    reg reset;
   	reg [`DATA_W-1:0] data_in;
   	reg read;
   	reg write;
   	
   	//Outputs
   	wire [`DATA_W-1:0] data_out;
   	wire empty_out;
   	wire full_out;
    reg [31:0] fifo_occupancy;

    integer i;

    parameter clk_per = 10; // clk period = 10 timeticks
    

    initial begin
        // optional VCD
        `ifdef VCD
            if(`USE_RAM==0) begin
                $dumpfile("sfifo.vcd");
                $dumpvars();
            end
            if(`USE_RAM==1) begin
                $dumpfile("sfifo_ram.vcd");
                $dumpvars();
            end
        `endif

        //Initialize Inputs
        clk = 1;
        reset = 0;
        data_in = 0;
        read = 0;
        write = 0;

         //Write all the locations of FIFO
        #clk_per;
        @(posedge clk) #1; 
        reset = 1;
        @(posedge clk) #1;
        reset = 0;
        
        @(posedge clk) #1;
        write = 1;
        for(i=0; i < 16; i = i + 1) begin
            data_in = i+32;
            @(posedge clk) #1;
        end
       
        @(posedge clk) #1;
        write = 0; //Fifo is now full
        if(fifo_occupancy != 16 && full_out!=1) begin
            $display("Test 1 failed: fifo not full.");
            $finish;
        end
        
        #clk_per
        @(posedge clk) #1;
        read=1;

        //Read all the locations of RAM. 
        if(`USE_RAM==1) @(posedge clk) #1;
        for(i=0; i < 16; i = i + 1) begin
            // Result will only be available in the next cycle
            if(data_out != i+32) begin
                $display("Test 2 failed: read error in data_out.\n \t i=%0d; data=%d when it should have been %0d", i, data_out, i+32);
                $finish;
            end
            @(posedge clk) #1;
        end

        @(posedge clk) #1;
        read = 0; //Fifo is now empty
        @(posedge clk) #1;
        if(fifo_occupancy != 0 && empty_out!=1) begin
            $display("Test 3 failed: fifo not empty.\n \t occupancy=%d;", fifo_occupancy);
            $finish;
        end

        // Test reset
        @(posedge clk) #1;
        write = 1;
        for(i=0; i < 16; i = i + 1) begin
            data_in = i+32;
            @(posedge clk) #1;
        end

        write = 0; //Fifo is now full
        if(fifo_occupancy != 16 && full_out!=1) begin
            $display("Test 4 failed: fifo not full.");
            $finish;
        end

        @(posedge clk) #1;
        reset = 1;
        @(posedge clk) #1;
        reset = 0;

        if(fifo_occupancy != 0 && empty_out!= 1) begin
            $display("Test 5 failed: reset did not work");
            $finish;
        end

        #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
        #(5*clk_per) $finish;

    end

   	// Instantiate the Unit Under Test (UUT)
    iob_sync_fifo #(
    	.DATA_WIDTH(`DATA_W), 
    	.ADDRESS_WIDTH(`ADDR_W),
    	.USE_RAM(`USE_RAM)
	) uut (
		.clk(clk), 
		.rst(reset), 
		.data_in(data_in), 
		.data_out(data_out), 
		.empty(empty_out), 
		.read_en(read), 
		.full(full_out), 
		.write_en(write),
        .fifo_ocupancy(fifo_occupancy)
	);
    
    // system clock
	always #(clk_per/2) clk = ~clk; 

endmodule // sfifo_tb
