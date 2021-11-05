`timescale 1ns/1ps

/* WARNING: This memory assumes that the write port data width and the
 read port data width are multiples of eachother
 */
module iob_sync_fifo_asym_with_sym_mem
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
    output [R_DATA_W-1:0] data_out,
    output                empty,
    input                 read_en,

    //write port
    input [W_DATA_W-1:0]  data_in,
    output                full,
    input                 write_en
    );

  generate if (W_DATA_W > R_DATA_W)
  begin
    iob_sync_fifo_asym_with_sym_mem_w_big #(
      .W_DATA_W(W_DATA_W),
      .W_ADDR_W(W_ADDR_W),
      .R_DATA_W(R_DATA_W),
      .R_ADDR_W(R_ADDR_W),
      .USE_RAM(USE_RAM)
    ) asym_fifo_with_sym_mem (
      .rst            (rst),
      .clk            (clk),
      .fifo_ocupancy  (fifo_ocupancy),
      .data_out       (data_out),
      .empty          (empty),
      .read_en        (read_en),
      .data_in        (data_in),
      .full           (full),
      .write_en         (write_en)
    );
  end
  else
  begin
    iob_sync_fifo_asym_with_sym_mem_r_big #(
      .W_DATA_W(W_DATA_W),
      .W_ADDR_W(W_ADDR_W),
      .R_DATA_W(R_DATA_W),
      .R_ADDR_W(R_ADDR_W),
      .USE_RAM(USE_RAM)
    ) asym_fifo_with_sym_mem (
      .rst            (rst),
      .clk            (clk),
      .fifo_ocupancy  (fifo_ocupancy),
      .data_out       (data_out),
      .empty          (empty),
      .read_en        (read_en),
      .data_in        (data_in),
      .full           (full),
      .write_en         (write_en)
    );
  end
  endgenerate
endmodule
