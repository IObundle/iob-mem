ifneq (iob_fifo_async_asym,$(filter iob_fifo_async_asym,, $(MODULES)))

# Add to modules list
MODULES+=iob_fifo_async_asym

# Paths
AFIFO_ASYM_DIR=$(MEM_FIFO_DIR)/iob_fifo_async_asym

# Submodules
include $(MEM_RAM_DIR)/iob_ram_t2p_asym/hardware.mk
include $(MEM_FIFO_DIR)/gray_counter/hardware.mk
include $(MEM_FIFO_DIR)/gray2bin/hardware.mk

# Sources
VSRC+=$(AFIFO_ASYM_DIR)/iob_fifo_async_asym.v

endif
