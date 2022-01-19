ifneq (iob_async_fifo,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_async_fifo

# Paths
AFIFO_DIR=$(MEM_FIFO_DIR)/iob_async_fifo

# Submodules
include $(MEM_RAM_DIR)/iob_ram_t2p/hardware.mk
include $(MEM_FIFO_DIR)/gray2bin/hardware.mk
include $(MEM_FIFO_DIR)/gray_counter/hardware.mk

# Sources
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v

endif
