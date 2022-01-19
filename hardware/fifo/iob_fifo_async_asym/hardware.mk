ifneq (iob_fifo_async_asym,$(filter iob_fifo_async_asym, $(MODULES)))

# Sources
VSRC+=$(MEM_HW_DIR)/fifo/iob_fifo_async_asym/iob_fifo_async_asym.v

# Add to modules list
MODULES+=iob_fifo_async_asym

# Submodules
include $(MEM_HW_DIR)/ram/iob_ram_t2p_asym/hardware.mk
include $(MEM_HW_DIR)/fifo/gray_counter/hardware.mk
include $(MEM_HW_DIR)/fifo/gray2bin/hardware.mk

endif
