`timescale 1ns / 1ps

`ifdef R_BIG
    `define W_DATA 8
    `define W_ADDR 4
    `define R_DATA 32
    `define R_ADDR 2
`endif

`ifndef R_BIG
    `define R_BIG 0
    `define W_DATA 32
    `define W_ADDR 2
    `define R_DATA 8
    `define R_ADDR 4
`endif

module sfifo_assim_tb;

    //Inputs
    reg clk;
    reg reset;
    reg [`W_DATA-1:0] data_in;
    reg read;
    reg write;

    //Ouptuts
    wire [`R_DATA-1:0] data_out;
    wire empty_out;
    wire full_out;
    wire [31:0] fifo_occupancy;

    integer i;

    parameter clk_per = 10; // clk period = 10 timeticks

    // Instantiate the Unit Under Test (UUT)
    iob_sync_assim_fifo #(
        .W_DATA_W(`W_DATA), 
        .W_ADDR_W(`W_ADDR),
        .R_DATA_W(`R_DATA),
        .R_ADDR_W(`R_ADDR)
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

    always
    #(clk_per/2) clk = ~clk; 

    initial begin
        //Initialize Inputs
        clk = 0;
        reset = 0;
        data_in = 0;
        read = 0;
        write = 0;

        @(posedge clk) #1;
        reset = 1;
        @(posedge clk) #1;
        reset = 0;

        // W_DATA > R_DATA
        if(`R_BIG==0) begin
            // optional VCD
            `ifdef VCD
                $dumpfile("sfifo_assim_w.vcd");
                $dumpvars();
            `endif

            //Write all the locations of FIFO
            write = 1;
            for(i=0; i < 4; i = i + 1) begin
                data_in[7:0] = i*4;
                data_in[15:8] = i*4+1;
                data_in[23:16] = i*4+2;
                data_in[31:24] = i*4+3;
                @(posedge clk) #1;
            end
            write = 0; //Fifo is now full

            if(fifo_occupancy!=16) begin
                $display("Test failed: fifo not full");
                $finish;
            end

            //Read all the locations of RAM. 
            read = 1;
            for(i=0; i < 16; i = i + 1) begin
                @(posedge clk) #1;
            end
        end

        // R_DATA > W_DATA
        if(`R_BIG==1) begin
            // optional VCD
            `ifdef VCD
                $dumpfile("sfifo_assim_r.vcd");
                $dumpvars();
            `endif

            //Write all the locations of FIFO
            write = 1;
            for(i=0; i < 16; i = i + 1) begin
                data_in = i;
                @(posedge clk) #1;
            end
            write = 0; //Fifo is now full

            if(fifo_occupancy!=16) begin
                $display("Test failed: fifo not full");
                $finish;
            end

            //Read all the locations of RAM. 
            read = 1;
            for(i=0; i < 4; i = i + 1) begin
                @(posedge clk) #1;
                if(data_out[7:0]!=i*4 || data_out[15:8]!=i*4+1 || 
                    data_out[23:16]!=i*4+2 || data_out[31:24]!=i*4+3) begin
                    $display("Test failed: read error in data_out.\n\t");
                    $finish;
                end
            end
        end

        read = 0; //Fifo is now empty
        if(fifo_occupancy!=0) begin
                $display("Test failed: fifo not empty");
                $finish;
        end

        #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
        #(5*clk_per) $finish;
    end
endmodule // sfifo_assim_tb
