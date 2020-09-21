`timescale 1ns / 1ps

`define DATA_W 8
`define ADDR_W 4
`define hex_file1 "tb1.hex"
`define hex_file2 "tb2.hex"

module tdp_ram_tb;
	
	//Inputs
	reg               clk;

    reg [`DATA_W-1:0] data_a;
    reg [`ADDR_W-1:0] addr_a;
    reg               en_a;
    reg               we_a;

    reg [`DATA_W-1:0] data_b;
    reg [`ADDR_W-1:0] addr_b;
    reg               en_b;
    reg               we_b;
   	
   	//Outputs
   	reg [`DATA_W-1:0] q_a;
    reg [`DATA_W-1:0] q_b;

    // .hex file
    reg [7:0] filemem [0:15];

    integer i;

    parameter clk_per = 10; // clk period = 10 timeticks

    initial begin
        // optional VCD
        `ifdef VCD
           $dumpfile("tdp_ram.vcd");
           $dumpvars();
        `endif
        $dumpoff();
        
        //Initialize Inputs
        clk = 1;

        data_a = 0;
        addr_a = 0;
        en_a = 0;
        we_a = 0;

        data_b = 0;
        addr_b = 0;
        en_b = 0;
        we_b = 0;

        // store file for comparison
        #clk_per
        @(posedge clk) #1;
        $readmemh(`hex_file1, filemem);


        @(posedge clk) #1;
        en_a = 1;

        $dumpon();
        // read from file stored in port A
        @(posedge clk) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addr_a = i;
            @(posedge clk) #1;
            if(filemem[i]!= q_a) begin
                $display("Test failed: read error in port A position %d, where tb1.hex=%h but q_a=%h", i, filemem[i], q_a);
                $finish;
            end
        end

        #clk_per

        @(posedge clk) #1;
        en_b = 1;


          // read from file stored in port B
        @(posedge clk) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addr_b = i;
            @(posedge clk) #1;
            if(filemem[i]!= q_b) begin
                $display("Test failed: read error in port B position %d, where tb1.hex=%h but q_b=%h", i, filemem[i], q_b);
                $finish;
            end
        end
        $dumpoff();

        #clk_per

        $readmemh(`hex_file2, filemem);

        // write into port A and read from it
        @(posedge clk) #1;
        we_a = 1;

        for(i = 0; i < 16; i = i + 1) begin
            addr_a = i;
            data_a = filemem[i];
            @(posedge clk) #1;
        end

        @(posedge clk) #1;
        we_a = 0;

        @(posedge clk) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addr_a = i;
            @(posedge clk) #1;
            if(filemem[i]!= q_a) begin
                $display("Test failed: write error in port A position %d, where tb2.hex=%h but q_a=%h", i, filemem[i], q_a);
                $finish;
            end
        end

            // write into port B and read from it
        @(posedge clk) #1;
        we_b = 1;

        for(i = 0; i < 16; i = i + 1) begin
            addr_b = i;
            data_b = filemem[i];
            @(posedge clk) #1;
        end

        @(posedge clk) #1;
        we_b = 0;

        @(posedge clk) #1;
        for(i = 0; i < 16; i = i + 1) begin
            addr_b = i;
            @(posedge clk) #1;
            if(filemem[i]!= q_b) begin
                $display("Test failed: write error in port B position %d, where tb2.hex=%h but q_b=%h", i, filemem[i], q_b);
                $finish;
            end
        end

        @(posedge clk) #1;
        en_a = 0;
        en_b = 0;

        #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
        #(5*clk_per) $finish;

    end

    // Instantiate the Unit Under Test (UUT)
    iob_tdp_ram #(
        .DATA_W(`DATA_W), 
        .ADDR_W(`ADDR_W),
        .MEM_INIT_FILE(`hex_file1)
    ) uut (
        .clk(clk), 
        .data_a(data_a),
        .addr_a(addr_a),
        .en_a(en_a),
        .we_a(we_a),
        .q_a(q_a),
        .data_b(data_b),
        .addr_b(addr_b),
        .en_b(en_b),
        .we_b(we_b),
        .q_b(q_b)
    );
    
    // system clock
    always #(clk_per/2) clk = ~clk; 

endmodule // tdp_ram_tb
