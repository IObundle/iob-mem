# Submodules
include $(MEM_HW_DIR)/ram/t2p_ram/hardware.mk

# Sources
AFIFO_DIR=$(MEM_HW_DIR)/fifo/afifo
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v
