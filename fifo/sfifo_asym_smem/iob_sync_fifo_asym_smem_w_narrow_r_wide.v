`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}


/* WARNING: This memory assumes that the write port data width is smaller than the
  read port data width and are multiples of eachother
 */
module iob_sync_fifo_asym_smem_w_narrow_r_wide
  #(
    parameter W_DATA_W = 8,
    parameter W_ADDR_W = 7,
    parameter R_DATA_W = 32,
    parameter R_ADDR_W = 5,
    parameter USE_RAM = 1
  )
  (
    input                 rst,
    input                 clk,

    output reg [31:0]     fifo_ocupancy,


    //read port
    output [R_DATA_W-1:0] r_data,
    output                empty,
    input                 read_en,

    //write port
    input [W_DATA_W-1:0]  w_data,
    output                full,
    input                 write_en
    );

   //local variables
   localparam maxADDR_W = `max(W_ADDR_W, R_ADDR_W);
   localparam minADDR_W = `min(W_ADDR_W, R_ADDR_W);
   localparam maxDATA_W = `max(W_DATA_W, R_DATA_W);
   localparam minDATA_W = `min(W_DATA_W, R_DATA_W);
   localparam RATIO = maxDATA_W / minDATA_W;
   localparam FIFO_DEPTH = (2**maxADDR_W);

   //WRITE DOMAIN
   wire [W_ADDR_W-$clog2(RATIO)-1:0]    wptr;
   wire                   write_en_int;

   //READ DOMAIN
   wire [R_ADDR_W-1:0]    rptr;
   wire                   read_en_int;

   //FIFO ocupancy counter
  always @ (posedge clk or posedge rst)
    if (rst)
      fifo_ocupancy <= 0;
    else if (write_en_int & !read_en_int)
      fifo_ocupancy <= fifo_ocupancy+1;
    else if (read_en_int & !write_en_int)
      fifo_ocupancy <= fifo_ocupancy-RATIO;
    else if (read_en_int & write_en_int)
      fifo_ocupancy <= fifo_ocupancy-RATIO+1;

  //WRITE DOMAIN LOGIC
  //effective write enable
  assign write_en_int = write_en & ~full;
  assign full = (fifo_ocupancy == FIFO_DEPTH);

  wire [$clog2(RATIO):0] wmem_choice;

  bin_counter #(
    maxADDR_W-$clog2(RATIO)
  ) wptr_counter (
    .clk(clk),
    .rst(rst),
    .en(wmem_choice==RATIO-1),
    .data_out(wptr)
  );


  bin_counter #(
    $clog2(RATIO+1)
  ) wmem_counter (
    .clk(clk),
    .rst(rst || wmem_choice==RATIO),
    .en(write_en_int),
    .data_out(wmem_choice)
  );

  reg [RATIO-1:0] wmem_sel;
  always @* begin
      wmem_sel  = 0;
      wmem_sel[wmem_choice] = 1'b1;
  end

  //READ DOMAIN LOGIC
  //effective read enable
  assign read_en_int  = read_en & ~empty;
  assign empty = (fifo_ocupancy == 0);

  bin_counter #(
    R_ADDR_W
  ) rptr_counter (
    .clk(clk),
    .rst(rst),
    .en(read_en_int),
    .data_out(rptr)
  );

  // Generate RATIO dp_rams
  genvar i;
  generate
  // Vector containing all BRAM outputs
    wire [W_DATA_W-1:0] r_data_vec [RATIO-1:0];
    for(i = 0; i < RATIO; i = i + 1) begin : fifo_memory
      //FIFO memory
      iob_2p_ram #(
        .DATA_W(minDATA_W),
        .ADDR_W(minADDR_W),
        .USE_RAM(USE_RAM)
      ) fifo_mem (
        .clk(clk),
        .w_en(write_en_int & wmem_sel[i]),
        .w_data(w_data),
        .w_addr(wptr),
        .r_addr(rptr),
        .r_en(read_en_int),
        .r_data(r_data_vec[i])
      );
      assign r_data[minDATA_W*i +: minDATA_W] = r_data_vec[i];
    end
  endgenerate

endmodule
