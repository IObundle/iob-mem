# Submodules
include $(MEM_DIR)/ram/2p_asym_ram/hardware.mk

# Sources
ifneq (SFIFO_ASYM,$(filter SFIFO_ASYM, $(SUBMODULES)))
SUBMODULES+=SFIFO_ASYM
SFIFO_ASYM_DIR=$(MEM_DIR)/fifo/sfifo_asym
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v
endif
