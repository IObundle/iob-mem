`timescale 1ns/1ps

module iob_2p_mem
	#( 
		parameter DATA_W = 8,
		parameter ADDR_W = 6
	) 
	(
		//Inputs
		input 				clk,
        input 				w_en,    //write enable
        input [DATA_W-1:0] 	data_in, //Input data to write port
        input [ADDR_W-1:0] 	w_addr,  //address for write port
        input [ADDR_W-1:0] 	r_addr,  //address for read port
        input 				w_port_en,
        input				r_port_en,
        //Outputs
        output reg [DATA_W-1:0] data_out //output port
    );

	//memory declaration.
	reg [DATA_W-1:0] ram [2**ADDR_W-1:0];

	//writing to the RAM
	always@(posedge clk)
	begin
		if(w_en == 1 && w_port_en)    //check if write enable is ON
		    ram[w_addr] <= data_in;
		else
			data_out <= r_port_en ? ram[r_addr] : 'dZ;
	end

endmodule   
