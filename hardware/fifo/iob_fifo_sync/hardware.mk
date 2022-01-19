ifneq (iob_sync_fifo,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_sync_fifo

# Paths
SFIFO_DIR=$(MEM_FIFO_DIR)/iob_sync_fifo

# Submodules
include $(MEM_RAM_DIR)/iob_ram_2p/hardware.mk
include $(MEM_FIFO_DIR)/bin_counter/hardware.mk

# Sources
VSRC+=$(SFIFO_DIR)/iob_sync_fifo.v

endif
