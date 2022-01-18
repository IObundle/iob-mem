MEM_NAME ?= sfifo_asym
include $(MEM_DIR)/config.mk

# Paths
SFIFO_ASYM_DIR=$(MEM_HW_DIR)/fifo/sfifo_asym

# Submodules
ifneq (2p_asym_ram,$(filter 2p_asym_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/2p_asym_ram/hardware.mk
endif

ifneq (bin_counter,$(filter bin_counter, $(MODULES)))
BIN_COUNTER_DIR=$(MEM_HW_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v
MODULES+=bin_counter
endif

# Sources
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v
