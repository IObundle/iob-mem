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

module iob_2p_assim_async_mem_tb;

    // Inputs
    bit wclk;
    bit rclk;
    reg w_en;
    reg r_en;
    reg [`W_DATA-1:0] data_in;
    reg [`W_ADDR-1:0] w_addr;
    reg [`R_ADDR-1:0] r_addr;

    // Outputs
    wire [`R_DATA-1:0] data_out;

    integer i, seq_ini;

    parameter clk_per = 10; // clk period = 10 timeticks

    // Instantiate the Unit Under Test (UUT)
    iob_2p_assim_async_mem #(
        .W_DATA_W(`W_DATA),
        .W_ADDR_W(`W_ADDR),
        .R_DATA_W(`R_DATA),
        .R_ADDR_W(`R_ADDR)
    )
    uut (
        .wclk(wclk), 
        .w_en(w_en),
        .r_en(r_en), 
        .data_in(data_in), 
        .w_addr(w_addr),
	.rclk(rclk),
        .r_addr(r_addr),
        .data_out(data_out)
    );

    // system clock
    always #(clk_per/2) wclk = ~wclk; 
    always #(clk_per/2) rclk = ~rclk;
   
    initial begin
        // Initialize Inputs
        rclk = 0;
        wclk = 1;
        w_addr = 0;
        w_en = 0;
        r_en = 0;
        data_in = 0;
        r_addr = 0; 

        // Number from which to start the incremental sequence to write into the RAM
        seq_ini = 32;

        // Read data > write data
        if(`R_BIG==1) begin
            // optional VCD
            `ifdef VCD
                $dumpfile("2p_assim_mem_r.vcd");
                $dumpvars();
            `endif
            @(posedge wclk) #1;

            //Write all the locations of RAM 
            w_en = 1; 
            for(i = 0; i < 16; i = i + 1) begin
                w_addr = i;
                data_in = i+seq_ini;
                @(posedge wclk) #1;
            end
            w_en = 0;

            @(posedge rclk) #1;

            //Read all the locations of RAM
            r_en = 1;
            for(i = 0 ; i < 4; i = i + 1) begin
                r_addr = i;
                @(posedge rclk) #1;
                if(data_out[7:0]!=i*4+seq_ini || data_out[15:8]!=i*4+1+seq_ini || 
                    data_out[23:16]!=i*4+2+seq_ini || data_out[31:24]!=i*4+3+seq_ini) begin
                    $display("Test 1 failed: read error in data_out.\n\t");
                    $finish;
                end
                @(posedge rclk) #1;
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
                w_addr = i;
                #(clk_per);
                @(posedge wclk) #1;
            end
            w_en = 0;

            @(posedge rclk) #1;
            
            //Read all the locations of RAM
            r_en = 1; 
            for(i=0; i < 16; i = i + 1) begin
                r_addr = i;
                @(posedge rclk) #1;
                if(data_out!=i+seq_ini) begin
                    $display("Test 2 failed: read error in data_out. \n \t i=%0d; data = %h when it should have been %0h", 
                        i, data_out, i+32);
                end
            end
            @(posedge rclk) #1;
            r_en = 0;
        end

        #clk_per
        $display("%c[1;34m",27);
        $display("Test completed successfully.");
        $display("%c[0m",27);
        #(5*clk_per) $finish;
    end
endmodule
