# Submodules
include $(MEM_DIR)/ram/2p_ram/hardware.mk

ifneq (BIN_COUNTER,$(filter BIN_COUNTER, $(SUBMODULES)))
SUBMODULES+=BIN_COUNTER
BIN_COUNTER_DIR=$(MEM_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v
endif

# Sources
ifneq (SFIFO,$(filter SFIFO, $(SUBMODULES)))
SUBMODULES+=SFIFO
SFIFO_DIR=$(MEM_DIR)/fifo/sfifo
VSRC+=$(SFIFO_DIR)/iob_sync_fifo.v
endif
