# Submodules
include $(MEM_HW_DIR)/ram/2p_asym_ram/hardware.mk

BIN_COUNTER_DIR=$(MEM_HW_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v

# Sources
SFIFO_ASYM_DIR=$(MEM_HW_DIR)/fifo/sfifo_asym
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v
