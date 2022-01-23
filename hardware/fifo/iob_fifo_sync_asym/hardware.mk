ifneq (iob_fifo_sync_asym,$(filter iob_fifo_sync_asym, $(MODULES)))

# Add to modules list
MODULES+=iob_fifo_sync_asym

# Paths
SFIFO_ASYM_DIR=$(MEM_FIFO_DIR)/iob_fifo_sync_asym

# Submodules
include $(LIB_DIR)/hardware/hardware.mk
include $(MEM_RAM_DIR)/iob_ram_2p_asym/hardware.mk

# Sources
VSRC+=$(SFIFO_ASYM_DIR)/iob_fifo_sync_asym.v

endif
