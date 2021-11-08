# Submodules
include $(MEM_DIR)/ram/t2p_asym_ram/hardware.mk

# Sources
ifneq (AFIFO_ASYM,$(filter AFIFO_ASYM, $(SUBMODULES)))
SUBMODULES+=AFIFO_ASYM
AFIFO_ASYM_DIR=$(MEM_DIR)/fifo/afifo_asym
VSRC+=$(AFIFO_ASYM_DIR)/iob_async_fifo_asym.v
endif
