`timescale 1ns/1ps

// Convert gray encoding to binary
module gray2bin #(
    parameter DATA_W = 4
    ) (
    input [DATA_W-1:0] gr,
    output [DATA_W-1:0] bin
    );

    reg [DATA_W-1:0]  bi;
    integer 	        i;
    integer 		    N = DATA_W;

    always @* begin
        bi[N-1] = gr[N-1];
        for (i=N-2;i>=0;i=i-1)
           bi[i] = gr[i] ^ bi[i+1];
    end

    assign bin = bi;

endmodule

