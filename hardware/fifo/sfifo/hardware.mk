# Submodules
include $(MEM_HW_DIR)/ram/2p_ram/hardware.mk

BIN_COUNTER_DIR=$(MEM_HW_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v

# Sources
SFIFO_DIR=$(MEM_HW_DIR)/fifo/sfifo
VSRC+=$(SFIFO_DIR)/iob_sync_fifo.v
