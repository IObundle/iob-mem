# Submodules
include $(MEM_DIR)/ram/2p_ram/hardware.mk

# Sources
ifneq (SFIFO,$(filter SFIFO, $(SUBMODULES)))
SUBMODULES+=SFIFO
SFIFO_DIR=$(MEM_DIR)/fifo/sfifo
VSRC+=$(SFIFO_DIR)/iob_sync_fifo.v
endif
