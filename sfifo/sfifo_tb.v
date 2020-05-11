`timescale 1ns / 1ps

module sfifo_tb;
	
	//Inputs
	reg clk;
    reg reset;
   	reg [7:0] data_in;
   	reg read;
   	reg write;
   	
   	//Ouptuts
   	wire [7:0] data_out;
   	wire empty_out;
   	wire full_out;

    integer i;
    
   	// Instantiate the Unit Under Test (UUT)
    iob_sync_fifo #(
    	.DATA_WIDTH(8), 
    	.ADDRESS_WIDTH(4),
    	.USE_RAM(1)
	) uut (
		.clk(clk), 
		.rst(reset), 
		.data_in(data_in), 
		.data_out(data_out), 
		.empty(empty_out), 
		.read_en(read), 
		.full(full_out), 
		.write_en(write)
	);
    
	always
		#5 clk = ~clk; 

    initial begin
    
    	$dumpfile("sfifo.vcd");
    	$dumpvars();
    	
    	//Initialize Inputs
        clk = 0;
        reset = 0;
        data_in = 0;
        read = 0;
        write = 0;
        
         //Write all the locations of FIFO
   		#15;
        @(posedge clk) reset = 1;
        #10
        @(posedge clk) reset = 0;
        $display("out=%d full=%b empty=%b",data_out, full_out, empty_out);
        #20;
		for(i=1; i <= 16; i = i + 1) begin
        	@(posedge clk) write = 1;
			data_in = i;
		end
        @(posedge clk) write = 0; //Fifo is now full
        
        #10
        @(posedge clk) read=1;
        //Read all the locations of RAM. 
		for(i=1; i <= 16; i = i + 1) begin
			//Result will only be available in the next cycle
			@(posedge clk) $display("out=%d full=%b empty=%b",data_out, full_out, empty_out);
		end
		@(posedge clk) read = 0; //Fifo is now empty
        #50;
        @(posedge clk) $display("out=%d full=%b empty=%b",data_out, full_out, empty_out);
        $finish;
    end


endmodule // sfifo_tb


