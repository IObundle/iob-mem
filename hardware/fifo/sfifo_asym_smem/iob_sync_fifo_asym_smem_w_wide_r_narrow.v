`timescale 1ns/1ps

`define max(a,b) {(a) > (b) ? (a) : (b)}
`define min(a,b) {(a) < (b) ? (a) : (b)}


/* WARNING: This memory assumes that the write port data width is bigger than the
  read port data width and are multiples of eachother
 */
module iob_sync_fifo_asym_smem_w_wide_r_narrow
  #(
    parameter W_DATA_W = 32,
    parameter W_ADDR_W = 5,
    parameter R_DATA_W = 8,
    parameter R_ADDR_W = 7,
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
   wire [W_ADDR_W-1:0]    wptr;
   wire                   write_en_int;

   //READ DOMAIN
   wire [R_ADDR_W-$clog2(RATIO)-1:0]    rptr;
   wire                   read_en_int;

   //FIFO ocupancy counter
	always @ (posedge clk or posedge rst)
	  if (rst)
	    fifo_ocupancy <= 0;
	  else if (write_en_int & !read_en_int)
	    fifo_ocupancy <= fifo_ocupancy+RATIO;
	  else if (read_en_int & !write_en_int)
	    fifo_ocupancy <= fifo_ocupancy-1;
	  else if (read_en_int & write_en_int)
	    fifo_ocupancy <= fifo_ocupancy+RATIO-1;

  //WRITE DOMAIN LOGIC
  //effective write enable
  assign write_en_int = write_en & ~full;
  assign full = (fifo_ocupancy == FIFO_DEPTH);

  bin_counter #(
    W_ADDR_W
  ) wptr_counter (
   .clk(clk),
   .rst(rst),
   .en(write_en_int),
   .data_out(wptr)
  );

  wire [$clog2(RATIO)-1:0] rmem_choice;
  //READ DOMAIN LOGIC
  //effective read enable
  assign read_en_int  = read_en & ~empty;
  assign empty = (fifo_ocupancy == 0);

  bin_counter #(
    maxADDR_W-$clog2(RATIO)
  ) rptr_counter (
    .clk(clk),
    .rst(rst),
    .en(rmem_choice==RATIO-2),
    .data_out(rptr)
  );

  reg read_en_int_delay;
  always @ (posedge clk)
    read_en_int_delay <= read_en_int;

  bin_counter #(
    $clog2(RATIO)
  ) rmem_counter (
    .clk(clk),
    .rst(rst || rmem_choice==RATIO),
    .en(read_en_int_delay),
    .data_out(rmem_choice)
  );

  // Generate RATIO dp_rams
  genvar i;
  generate
  // Vector containing all BRAM outputs
    wire [R_DATA_W-1:0] r_data_vec [RATIO-1:0];
    for(i = 0; i < RATIO; i = i + 1) begin : fifo_memory
      //FIFO memory
      iob_2p_ram #(
        .DATA_W(minDATA_W),
        .ADDR_W(minADDR_W),
        .USE_RAM(USE_RAM)
      ) fifo_ram (
        .clk(clk),
        .w_en(write_en_int),
        .w_data(w_data[minDATA_W*i +: minDATA_W]),
        .w_addr(wptr),
        .r_addr(rptr),
        .r_en(read_en_int),
        .r_data(r_data_vec[i])
      );
    end
  endgenerate

  reg [R_DATA_W-1:0] r_data_tmp;

  always @*
    r_data_tmp = r_data_vec[rmem_choice];

  assign r_data = r_data_tmp;

endmodule
