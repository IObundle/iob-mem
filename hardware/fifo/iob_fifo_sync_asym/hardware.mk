<<<<<<< HEAD
ifneq (iob_fifo_sync_asym,$(filter $S, $(MODULES)))
=======
ifneq (iob_fifo_sync_asym,$(filter iob_fifo_sync_asym, $(MODULES)))
>>>>>>> bd4957c41a98b22d8674d6835f5921ffdb292c35

# Add to modules list
MODULES+=iob_fifo_sync_asym

# Paths
SFIFO_ASYM_DIR=$(MEM_FIFO_DIR)/iob_fifo_sync_asym

# Submodules
include $(MEM_RAM_DIR)/iob_ram_2p_asym/hardware.mk

# Sources
VSRC+=$(SFIFO_ASYM_DIR)/iob_fifo_sync_asym.v

endif
