`timescale 1ns / 1ps

`define DATA_W 8
`define ADDR_W 4

module sfifo_tb;
	
	//Inputs
	reg clk;
    reg reset;
   	reg [`DATA_W-1:0] data_in;
   	reg read;
   	reg write;
   	
   	//Ouptuts
   	wire [`DATA_W-1:0] data_out;
   	wire empty_out;
   	wire full_out;
    reg [31:0] fifo_occupancy;

    integer i;

    parameter clk_per = 10; // clk period = 10 timeticks
    

    initial begin
        // optional VCD
        `ifdef VCD
      	   $dumpfile("sfifo.vcd");
      	   $dumpvars();
        `endif
      	
        //Initialize Inputs
        clk = 1;
        reset = 0;
        data_in = 0;
        read = 0;
        write = 0;

         //Write all the locations of FIFO
        #10;
        @(posedge clk) #1; 
        reset = 1;
        @(posedge clk) #1;
        reset = 0;
        
        @(posedge clk) #1;
        write = 1;
        for(i=0; i < 16; i = i + 1) begin
            data_in = i;
            @(posedge clk) #1;
        end
       
        @(posedge clk) #1;
        write = 0; //Fifo is now full
        if(fifo_occupancy != 16 && full_out!=1) begin
            $display("Test failed: fifo not full.");
            $finish;
        end
        
        #10
        @(posedge clk) #1;
        read=1;
        //Read all the locations of RAM. 
        for(i=0; i < 16; i = i + 1) begin
            // Result will only be available in the next cycle
            if(data_out != i) begin
                $display("Test failed: read error in data_out.\n \t i=%d; data=%d", i, data_out);
                $finish;
            end
            @(posedge clk) #1;
        end

        @(posedge clk) #1;
        read = 0; //Fifo is now empty
        @(posedge clk) #1;
        if(fifo_occupancy != 0 && empty_out!=1) begin
            $display("Test failed: fifo not empty.\n \t occupancy=%d;", fifo_occupancy);
            $finish;
        end

        #clk_per
        $display("Test completed successfully.");
        #(5*clk_per) $finish;

    end

   	// Instantiate the Unit Under Test (UUT)
    iob_sync_fifo #(
    	.DATA_WIDTH(`DATA_W), 
    	.ADDRESS_WIDTH(`ADDR_W),
    	.USE_RAM(0)
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
