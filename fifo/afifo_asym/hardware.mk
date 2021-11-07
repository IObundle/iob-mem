include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/2p_asym_ram/hardware.mk

# Sources
ifneq (AFIFO,$(filter AFIFO, $(SUBMODULES)))
SUBMODULES+=AFIFO
AFIFO_DIR=$(FIFO_DIR)/afifo
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v
endif
