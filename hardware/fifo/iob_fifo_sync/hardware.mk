MEM_NAME ?= sfifo
include $(MEM_DIR)/config.mk
MODULES+=fifo/sfifo

# Paths
SFIFO_DIR=$(MEM_HW_DIR)/fifo/sfifo

# Submodules
ifneq (ram/2p_ram,$(filter ram/2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/2p_ram/hardware.mk
endif

ifneq (bin_counter,$(filter fifo/bin_counter, $(MODULES)))
BIN_COUNTER_DIR=$(MEM_HW_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v
MODULES+=bin_counter
endif

# Sources
VSRC+=$(SFIFO_DIR)/iob_sync_fifo.v
