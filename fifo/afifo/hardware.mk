# Submodules
include $(MEM_DIR)/ram/t2p_ram/hardware.mk

# Sources
ifneq (AFIFO,$(filter AFIFO, $(SUBMODULES)))
SUBMODULES+=AFIFO
AFIFO_DIR=$(MEM_DIR)/fifo/afifo
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v
endif
