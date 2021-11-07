include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/2p_asym_ram/hardware.mk

# Sources
ifneq (SFIFO_ASYM,$(filter SFIFO_ASYM, $(SUBMODULES)))
SUBMODULES+=SFIFO_ASYM
FIFO_ASYM_DIR=$(FIFO_DIR)/sfifo_asym
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v
endif
