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

module iob_t2p_asym_ram_tb;

    // Inputs
    bit wclk;
    bit rclk;
    reg w_en;
    reg r_en;
    reg [`W_DATA-1:0] w_data;
    reg [`W_ADDR-1:0] w_addr;
    reg [`R_ADDR-1:0] r_addr;

    // Outputs
    wire [`R_DATA-1:0] r_data;

    integer i, seq_ini;

    parameter clk_per = 10; // clk period = 10 timeticks

    // Instantiate the Unit Under Test (UUT)
    iob_t2p_asym_ram #(
        .W_DATA_W(`W_DATA),
        .W_ADDR_W(`W_ADDR),
        .R_DATA_W(`R_DATA),
        .R_ADDR_W(`R_ADDR)
    )
    uut (
        .wclk(wclk), 
        .w_en(w_en),
        .r_en(r_en), 
        .w_data(w_data), 
        .w_addr(w_addr),
	.rclk(rclk),
        .r_addr(r_addr),
        .r_data(r_data)
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
        w_data = 0;
        r_addr = 0; 

        // Number from which to start the incremental sequence to write into the RAM
        seq_ini = 32;

        // Read data > write data
        if(`R_BIG==1) begin
            // optional VCD
            `ifdef VCD
                $dumpfile("iob_t2p_asym_ram_r.vcd");
                $dumpvars();
            `endif
            @(posedge wclk) #1;

            //Write all the locations of RAM 
            w_en = 1; 
            for(i = 0; i < 16; i = i + 1) begin
                w_addr = i;
                w_data = i+seq_ini;
                @(posedge wclk) #1;
            end
            w_en = 0;

            @(posedge rclk) #1;

            //Read all the locations of RAM
            r_en = 1;
            for(i = 0 ; i < 4; i = i + 1) begin
                r_addr = i;
                @(posedge rclk) #1;
                if(r_data[7:0]!=i*4+seq_ini || r_data[15:8]!=i*4+1+seq_ini || 
                    r_data[23:16]!=i*4+2+seq_ini || r_data[31:24]!=i*4+3+seq_ini) begin
                    $display("Test 1 failed: read error in r_data.\n\t");
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
                $dumpfile("iob_t2p_asym_ram_w.vcd");
                $dumpvars();
            `endif

            //Write all the locations of RAM 
            w_en = 1;
            for(i=0; i < 4; i = i + 1) begin
                w_data[7:0] = i*4      +seq_ini;
                w_data[15:8] = i*4+1   +seq_ini;
                w_data[23:16] = i*4+2  +seq_ini;
                w_data[31:24] = i*4+3  +seq_ini;
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
                if(r_data!=i+seq_ini) begin
                    $display("Test 2 failed: read error in r_data. \n \t i=%0d; data = %h when it should have been %0h", 
                        i, r_data, i+32);
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
