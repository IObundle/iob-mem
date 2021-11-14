`timescale 1ns/1ps

/* WARNING: This memory assumes that the write port data width and the
 read port data width are multiples of eachother
 */
module iob_sync_fifo_asym_smem
  #(
    parameter W_DATA_W = 8,
    parameter W_ADDR_W = 7,
    parameter R_ADDR_W = 6,
    parameter R_DATA_W = 16,
    parameter USE_RAM = 1
    )
   (
    input                 rst,
    input                 clk,

    output [31:0]         fifo_ocupancy,


    //read port
    output [R_DATA_W-1:0] r_data,
    output                empty,
    input                 read_en,

    //write port
    input [W_DATA_W-1:0]  w_data,
    output                full,
    input                 write_en
    );

  generate if (W_DATA_W > R_DATA_W)
  begin
    iob_sync_fifo_asym_smem_w_wide_r_narrow #(
      .W_DATA_W(W_DATA_W),
      .W_ADDR_W(W_ADDR_W),
      .R_DATA_W(R_DATA_W),
      .R_ADDR_W(R_ADDR_W),
      .USE_RAM(USE_RAM)
    ) asym_fifo_smem (
      .rst            (rst),
      .clk            (clk),
      .fifo_ocupancy  (fifo_ocupancy),
      .r_data         (r_data),
      .empty          (empty),
      .read_en        (read_en),
      .w_data         (w_data),
      .full           (full),
      .write_en         (write_en)
    );
  end
  else
  begin
    iob_sync_fifo_asym_smem_w_narrow_r_wide #(
      .W_DATA_W(W_DATA_W),
      .W_ADDR_W(W_ADDR_W),
      .R_DATA_W(R_DATA_W),
      .R_ADDR_W(R_ADDR_W),
      .USE_RAM(USE_RAM)
    ) asym_fifo_smem (
      .rst            (rst),
      .clk            (clk),
      .fifo_ocupancy  (fifo_ocupancy),
      .r_data         (r_data),
      .empty          (empty),
      .read_en        (read_en),
      .w_data         (w_data),
      .full           (full),
      .write_en         (write_en)
    );
  end
  endgenerate
endmodule
