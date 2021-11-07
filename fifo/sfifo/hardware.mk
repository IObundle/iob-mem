include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/2p_ram/hardware.mk

# Sources
ifneq (SFIFO,$(filter SFIFO, $(SUBMODULES)))
SUBMODULES+=SFIFO
SFIFO_DIR=$(FIFO_DIR)/sfifo
VSRC+=$(SFIFO_DIR)/iob_sync_fifo.v
endif
