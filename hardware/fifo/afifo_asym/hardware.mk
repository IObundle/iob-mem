# Submodules
include $(MEM_HW_DIR)/ram/t2p_asym_ram/hardware.mk

# Sources
FIFO_DIR=$(MEM_HW_DIR)/fifo
AFIFO_ASYM_DIR=$(MEM_HW_DIR)/fifo/afifo_asym
VSRC+=$(AFIFO_ASYM_DIR)/iob_async_fifo_asym.v
VSRC+=$(FIFO_DIR)/gray2bin.v
