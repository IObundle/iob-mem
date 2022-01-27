ifneq (iob_fifo_sync,$(filter iob_fifo_sync, $(MODULES)))

# Add to modules list
MODULES+=iob_fifo_sync

# Paths
SFIFO_DIR=$(MEM_FIFO_DIR)/iob_fifo_sync

# Submodules
include $(LIB_DIR)/hardware/hardware.mk
include $(MEM_RAM_DIR)/iob_ram_2p_asym/hardware.mk

# Sources
VSRC+=$(SFIFO_DIR)/iob_fifo_sync.v

endif
