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

module iob_2p_assim_mem_tb;

    // Inputs
    reg clk;
    reg w_en;
    reg r_en;
    reg [`W_DATA-1:0] data_in;
    reg [`W_ADDR-1:0] w_addr;
    reg [`R_ADDR-1:0] r_addr;

    // Outputs
    wire [`R_DATA-1:0] data_out;

    integer i, j, seq_ini;

    parameter clk_per = 10; // clk period = 10 timeticks

    // Instantiate the Unit Under Test (UUT)
    iob_2p_assim_mem #(
        .W_DATA_W(`W_DATA),
        .W_ADDR_W(`W_ADDR),
        .R_DATA_W(`R_DATA),
        .R_ADDR_W(`R_ADDR)
    )
    uut (
        .clk(clk), 
        .w_en(w_en),
        .r_en(r_en), 
        .data_in(data_in), 
        .w_addr(w_addr), 
        .r_addr(r_addr),
        .data_out(data_out)
    );

    // system clock
    always #(clk_per/2) clk = ~clk; 

    initial begin
        // Initialize Inputs
        clk = 1;
        w_addr = 0;
        w_en = 0;
        r_en = 0;
        data_in = 0;
        r_addr = 0; 
        seq_ini = 32; // number from which to start the sequence to write into the RAM

        // Read data > write data
        if(`R_BIG==1) begin
            // optional VCD
            `ifdef VCD
                $dumpfile("2p_assim_mem_r.vcd");
                $dumpvars();
            `endif
            @(posedge clk) #1;

            //Write all the locations of RAM 
            w_en = 1; 
            for(i = 0; i < (2**`W_ADDR); i = i + 1) begin
                w_addr = i;
                data_in = i+seq_ini;
                @(posedge clk) #1;
            end
            w_en = 0;

            @(posedge clk) #1;

            //Read all the locations of RAM
            r_en = 1;
            for(i = 0 ; i < (2**`R_ADDR); i = i + 1) begin
                r_addr = i;
                @(posedge clk) #1;
                for( j = 0; j < (2**`R_ADDR); j = j + 1 ) begin
                    //$display("data_out = %h", data_out[(j+1)*`W_DATA-1 -: `W_DATA]);
                    if(data_out[(j+1)*`W_DATA-1 -: `W_DATA] != j+seq_ini + i*(2**`R_ADDR)) begin
                        $display( "Test failed: read error in data_out.\n \t i=%0d; data = %h when it should have been %0h", 
                            (j+1)*(2**`R_ADDR)+i*(2**`R_ADDR), data_out, j+seq_ini + i*(2**`R_ADDR) );
                        $finish;
                    end
                end
            end
            r_en = 0;
        end

        // Write data > read data
        if(`R_BIG==0) begin
            // optional VCD
            `ifdef VCD
                $dumpfile("2p_assim_mem_w.vcd");
                $dumpvars();
            `endif

            //Write all the locations of RAM 
            w_en = 1;
            for(i=0; i < 4; i = i + 1) begin
                data_in[7:0] = i*4      +seq_ini;
                data_in[15:8] = i*4+1   +seq_ini;
                data_in[23:16] = i*4+2  +seq_ini;
                data_in[31:24] = i*4+3  +seq_ini;
                end
                $display("%h", data_in);
                w_addr = i;
                @(posedge clk) #1;
            end
            w_en = 0;

            @(posedge clk) #1;
            
            //Read all the locations of RAM
            r_en = 1; 
            for(i=0; i < 16; i = i + 1) begin
                r_addr = i;
                @(posedge clk) #1;
                if(data_out!=i+seq_ini) begin
                    $display("Test 2 failed: read error in data_out. \n \t i=%0d; data = %h when it should have been %0h", 
                        i, data_out, i+32);
                end
            end
            @(posedge clk) #1;
            r_en = 0;
        end


        #clk_per
        $display("Test completed successfully.");
        #(5*clk_per) $finish;
    end
endmodule
