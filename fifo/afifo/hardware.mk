include $(MEM_DIR)/mem.mk

# Submodules
include $(T2PRAM_DIR)/hardware.mk

# Sources
ifneq (AFIFO,$(filter AFIFO, $(SUBMODULES)))
SUBMODULES+=AFIFO
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v
endif
