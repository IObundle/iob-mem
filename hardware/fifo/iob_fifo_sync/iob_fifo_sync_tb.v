`timescale 1ns / 1ps
`include "iob_lib.vh"

//test defines
`define DATA_W 32
`define ADDR_W 10
`define TESTSIZE 256 //test size in bytes

module iob_fifo_sync_tb;
   
    localparam DATA_W = `DATA_W;
    localparam ADDR_W = `ADDR_W;
    localparam TESTSIZE = `TESTSIZE;
    
    //Inputs
    reg                 clk = 0;
    reg                 reset;
    reg [DATA_W-1:0]    w_data;
    reg                 r_en;
    reg                 w_en;

    //Outputs
    wire [DATA_W-1:0]   r_data;
    wire                r_empty;
    wire                w_full;
    reg [ADDR_W-1:0]    fifo_occupancy;

    integer             i, j;

    reg [DATA_W*2**ADDR_W-1:0] test_input;
    reg [DATA_W*2**ADDR_W-1:0] test_output;

    parameter clk_per = 10; // clk period = 10 timeticks
    always #(clk_per/2) clk = ~clk; 
   
    initial begin //writer process
        // initialize values
        w_en = 0;
        w_data = 0;
        i = 0;

        $display("DATA_W=%d", DATA_W);
        $display("ADDR_W=%d", ADDR_W);

        //create the test data bytes
        for(i=0;i< TESTSIZE; i=i+1)
            test_input[i*8 +: 8] = i;

        // optional VCD
`ifdef VCD
        $dumpfile("uut.vcd");
        $dumpvars();
`endif
        repeat(4) @(posedge clk) #1;

        //reset FIFO
        #clk_per;
        @(posedge clk) #1;
        reset = 1;
        @(posedge clk) #1;
        reset = 0;

        //pause for 1ms to allow the reader to test the empty flag
        #1000000 @(posedge clk) #1;

        //write test input to fifo
        for(i=0; i<((TESTSIZE*8)/DATA_W); i=i+1) begin
            if( i == ((TESTSIZE*8)/DATA_W/2) ) begin//another pause
                #1000000 @(posedge clk) #1;
            end

            if(!w_full) begin
                w_en = 1;
                w_data = test_input[i*DATA_W +: DATA_W];
                @(posedge clk) #1;
                w_en = 0;
            end
            @(posedge clk) #1;
        end

        #(5*clk_per) $finish;

    end // end of write process 

    initial begin //read process
        // initialize values
        r_en = 0;
        j = 0;

        @(negedge reset) repeat(4) @(posedge clk) #1;

        //read data from fifo
        for(j=0; j<((TESTSIZE*8)/DATA_W); j = j+1) begin
            //wait for data to read
            while(r_empty) begin
                @(posedge clk) #1;
            end

            if(!r_empty) begin
                r_en = 1;
                @(posedge clk) #1;
                test_output[j*DATA_W +: DATA_W] = r_data;
                r_en = 0;
            end
        end

        // compare written and read data
        if(test_output !== test_input)
            $display("ERROR: data read does not match the test data.");
    end // end of read process

   // Instantiate the Unit Under Test (UUT)
   iob_fifo_sync 
     #(
       .DATA_W(DATA_W), 
       .ADDR_W(ADDR_W)
       ) 
   uut 
     (
      .clk(clk), 
      .rst(reset), 
      .w_data(w_data), 
      .r_data(r_data), 
      .r_empty(r_empty), 
      .r_en(r_en), 
      .w_full(w_full), 
      .w_en(w_en),
      .fifo_ocupancy(fifo_occupancy)
      );
   

endmodule // iob_sync_fifo_tb
