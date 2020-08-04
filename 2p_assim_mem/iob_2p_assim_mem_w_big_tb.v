`timescale 1ns / 1ps

`define W_DATA_W 32
`define W_ADDR_W 2
`define R_DATA_W 8
`define R_ADDR_W 4


module iob_2p_assim_mem_w_big_tb;

    // Inputs
    reg clk;
    reg w_en;
    reg r_en;
    reg [`W_DATA_W-1:0] data_in;
    reg [`W_ADDR_W-1:0] w_addr;
    reg [`R_ADDR_W-1:0] r_addr;
    reg w_port_en;
    reg r_port_en;

    // Outputs
    wire [`R_DATA_W-1:0] data_out;
    
    integer i;

    // Instantiate the Unit Under Test (UUT)
    iob_2p_assim_mem_w_big #(
    	.W_DATA_W(`W_DATA_W),
    	.W_ADDR_W(`W_ADDR_W),
    	.R_DATA_W(`R_DATA_W),
    	.R_ADDR_W(`R_ADDR_W)
    )
     uut (
        .clk(clk), 
        .w_en(w_en),
        .r_en(r_en), 
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
    
    	$dumpfile("2p_assim_mem_w_big_tb.vcd");
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
		for(i=0; i < 4; i = i + 1) begin
			data_in[7:0] = i*4;
			data_in[15:8] = i*4+1;
			data_in[23:16] = i*4+2;
			data_in[31:24] = i*4+3;
			w_addr = i;
			@(posedge clk) #1;
		end
		w_port_en = 0;
		w_en = 0; 
		//Read all the locations of RAM
		r_port_en = 1; 
		for(i=0; i < 16; i = i + 1) begin
			r_addr = i;
			@(posedge clk) #1;
		end
		@(posedge clk) #1;
		 r_port_en = 0;
    #50 $finish;
    end
      
endmodule
