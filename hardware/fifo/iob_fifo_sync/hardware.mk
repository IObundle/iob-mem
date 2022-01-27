ifneq (iob_fifo_sync,$(filter iob_fifo_sync, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_fifo_sync

# Paths
SFIFO_DIR=$(MEM_FIFO_DIR)/iob_fifo_sync

# Submodules
include $(MEM_RAM_DIR)/iob_ram_2p_asym/hardware.mk

# Sources
VSRC+=$(SFIFO_DIR)/iob_fifo_sync.v

endif
