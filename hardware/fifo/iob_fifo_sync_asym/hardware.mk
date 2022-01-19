ifneq (iob_sync_fifo_asym,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_sync_fifo_asym

# Paths
SFIFO_ASYM_DIR=$(MEM_FIFO_DIR)/iob_sync_fifo_asym

# Submodules
include $(MEM_RAM_DIR)/iob_ram_2p_asym/hardware.mk
include $(MEM_FIFO_DIR)/bin_counter/hardware.mk

# Sources
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v

endif
