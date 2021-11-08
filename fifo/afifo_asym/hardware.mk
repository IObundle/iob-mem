include $(MEM_DIR)/core.mk

# Submodules
include $(2P_ASYM_RAM_DIR)/hardware.mk

# Sources
ifneq (AFIFO_ASYM,$(filter AFIFO_ASYM, $(SUBMODULES)))
SUBMODULES+=AFIFO_ASYM
VSRC+=$(AFIFO_ASYM_DIR)/iob_async_fifo_asym.v
endif
