ifeq ($(filter iob_fifo_async,$(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_fifo_async

# Submodules
include $(MEM_DIR)/hardware/ram/iob_ram_t2p_asym/hardware.mk
include $(MEM_DIR)/hardware/fifo/gray_counter/hardware.mk
include $(MEM_DIR)/hardware/fifo/gray2bin/hardware.mk

# Sources
VSRC+=$(MEM_DIR)/hardware/fifo/iob_fifo_async/iob_fifo_async.v

endif
