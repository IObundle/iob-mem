`timescale 1ns / 1ps
`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}

module iob_t2p_asym_ram 
  #(
    parameter W_DATA_W = 16,
    parameter W_ADDR_W = 6,
    parameter R_DATA_W = 8,
    parameter R_ADDR_W = 7
    )
   (
    //write port
    input                     w_clk,
    input                     w_en,
    input [W_DATA_W-1:0]      w_data,
    input [W_ADDR_W-1:0]      w_addr,

    //read port
    input                     r_clk,
    input                     r_en,
    input [R_ADDR_W-1:0]      r_addr,
    output reg [R_DATA_W-1:0] r_data
    );
   
   //determine the number of blocks N
   localparam MAXDATA_W = `max(W_DATA_W, R_DATA_W);
   localparam MINDATA_W = `min(W_DATA_W, R_DATA_W);
   localparam N = MAXDATA_W/MINDATA_W;
   localparam MAXADDR_W = `max(W_ADDR_W, R_ADDR_W);
   localparam MINADDR_W = `min(W_ADDR_W, R_ADDR_W);
  
  //memory buses
   //write buses
   reg [N-1:0]                en_wr;
   reg [MINDATA_W-1:0]        data_wr [N-1:0];
   reg [MINADDR_W-1:0]        addr_wr [N-1:0];

   //read buses
   wire [MINDATA_W-1:0]       data_rd [N-1:0];
   reg [MINADDR_W-1:0]        addr_rd [N-1:0];

   //instantiate N RAM blocks and connect them to the buses
   genvar                 i;
   generate 
      for (i=0; i<N; i=i+1) begin : t2p_ram_array
         iob_t2p_ram
             #(
               .DATA_W(MINDATA_W),
               .ADDR_W(MINADDR_W)
               )
         iob_t2p_ram_inst
             (
              .w_clk(w_clk),
              .w_en(en_wr[i]),
              .w_addr(addr_wr[i]),
              .w_data(data_wr[i]),

              .r_clk(w_clk),
              .r_en(r_en),
              .r_addr(addr_rd[i]),
              .r_data(data_rd[i])              
              );
         
      end
   endgenerate

   integer j,k,l;

   generate
      if (W_DATA_W > R_DATA_W) begin
          //write parallel
         always @* begin
            for (j=0; j < N; j= j+1) begin
               en_wr[j] = w_en;
               data_wr[j] = w_data[j*MINDATA_W +: MINDATA_W];
               addr_wr[j] = w_addr;
            end
         end
         
         //read serial
         always @* begin
            for (k=0; k < N; k= k+1) begin
               addr_rd[k] = r_addr[R_ADDR_W-1-:W_ADDR_W];
            end
         end

         //read address register
         reg [MAXDATA_W-MINDATA_W-1:0] r_addr_lsbs_reg;
         always @(posedge r_clk)
           r_addr_lsbs_reg <= r_addr[R_ADDR_W-W_ADDR_W-1:0];
           
         //read mux
         always @* begin
            r_data = 1'b0;
            for (l=0; l < N; l= l+1) begin
               r_data = data_rd[r_addr_lsbs_reg];
            end
         end
 
      end else begin
         //write serial
         always @* begin
            for (j=0; j < N; j= j+1) begin
               en_wr[j] = w_en & (w_addr[W_ADDR_W-R_ADDR_W-1:0] == j[W_ADDR_W-R_ADDR_W-1:0]);
               data_wr[j] = w_data;
               addr_wr[j] = w_addr[R_ADDR_W-1:0];
            end
         end
         //read parallel
         always @* begin
            for (k=0; k < N; k= k+1) begin
               addr_rd[k] = r_addr;
               r_data[k*MINDATA_W +: MINDATA_W] = data_rd[k];
            end
         end
    
      end
   endgenerate
endmodule

