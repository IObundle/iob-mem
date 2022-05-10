ifeq ($(filter iob_fifo_sync, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_fifo_sync

# Submodules
include $(MEM_DIR)/hardware/ram/iob_ram_2p_asym/hardware.mk

# Sources
VSRC+=$(MEM_DIR)/hardware/fifo/iob_fifo_sync/iob_fifo_sync.v

endif
