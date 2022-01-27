ifneq (iob_fifo_async,$(filter iob_fifo_async,, $(MODULES)))

# Add to modules list
MODULES+=iob_fifo_async

# Paths
AFIFO_DIR=$(MEM_FIFO_DIR)/iob_fifo_async

# Submodules
include $(LIB_DIR)/hardware/hardware.mk
include $(MEM_RAM_DIR)/iob_ram_t2p_asym/hardware.mk
include $(MEM_FIFO_DIR)/gray_counter/hardware.mk
include $(MEM_FIFO_DIR)/gray2bin/hardware.mk

# Sources
VSRC+=$(AFIFO_DIR)/iob_fifo_async.v

endif
