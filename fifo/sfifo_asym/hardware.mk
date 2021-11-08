include $(MEM_DIR)/mem.mk

# Submodules
include $(2P_ASYM_RAM_DIR)/hardware.mk

# Sources
ifneq (SFIFO_ASYM,$(filter SFIFO_ASYM, $(SUBMODULES)))
SUBMODULES+=SFIFO_ASYM
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v
endif
