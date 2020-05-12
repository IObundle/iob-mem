`timescale 1ns / 1ps

`define W_DATA_W 8
`define W_ADDR_W 4
`define R_DATA_W 32
`define R_ADDR_W 2

//Tests when the read data width is bigger than the write data width
module iob_2p_assim_mem_tb;

    // Inputs
    reg clk;
    reg w_en;
    reg [`W_DATA_W-1:0] data_in;
    reg [`W_ADDR_W-1:0] w_addr;
    reg [`R_ADDR_W-1:0] r_addr;
    reg w_port_en;
    reg r_port_en;

    // Outputs
    wire [`R_DATA_W-1:0] data_out;
    
    integer i;

    // Instantiate the Unit Under Test (UUT)
    iob_2p_assim_mem #(
    	.W_DATA_W(`W_DATA_W),
    	.W_ADDR_W(`W_ADDR_W),
    	.R_DATA_W(`R_DATA_W),
    	.R_ADDR_W(`R_ADDR_W)
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
    
    always
        #5 clk = ~clk;

    initial begin
    
    	$dumpfile("2p_assim_mem_tb.vcd");
    	$dumpvars();
        // Initialize Inputs
        clk = 1;
        w_addr = 0;
        w_en = 0;
        data_in = 0;
        r_addr = 0; 
        r_port_en = 0;
        w_port_en = 0; 
        @(posedge clk) #1;
        //Write all the locations of RAM 
        w_port_en = 1; 
        w_en = 1;
		for(i=0; i < 16; i = i + 1) begin
			data_in = i;
			w_addr = i;
			@(posedge clk) #1;
		end
		w_port_en = 0;
		w_en = 0; 
		
		//Read all the locations of RAM
		r_port_en = 1; 
		for(i=0; i < 4; i = i + 1) begin
			 r_addr = i;
			@(posedge clk) #1;
		end
		r_port_en = 0;
    #50 $finish;
    end
      
endmodule
