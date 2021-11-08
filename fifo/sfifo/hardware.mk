include $(MEM_DIR)/core.mk

# Submodules
include $(2PRAM_DIR)/hardware.mk

# Sources
ifneq (SFIFO,$(filter SFIFO, $(SUBMODULES)))
SUBMODULES+=SFIFO
VSRC+=$(SFIFO_DIR)/iob_sync_fifo.v
endif
