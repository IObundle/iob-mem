# Submodules
include $(MEM_HW_DIR)/ram/2p_asym_ram/hardware.mk

ifneq (BIN_COUNTER,$(filter BIN_COUNTER, $(SUBMODULES)))
SUBMODULES+=BIN_COUNTER
BIN_COUNTER_DIR=$(MEM_HW_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v
endif

# Sources
ifneq (SFIFO_ASYM,$(filter SFIFO_ASYM, $(SUBMODULES)))
SUBMODULES+=SFIFO_ASYM
SFIFO_ASYM_DIR=$(MEM_HW_DIR)/fifo/sfifo_asym
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v
endif
