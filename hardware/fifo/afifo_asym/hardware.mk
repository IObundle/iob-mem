MODULES+=fifo/afifo_asym

# Paths
FIFO_DIR=$(MEM_HW_DIR)/fifo
AFIFO_ASYM_DIR=$(MEM_HW_DIR)/fifo/afifo_asym

# Submodules
ifneq (ram/t2p_asym_ram,$(filter ram/t2p_asym_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/t2p_asym_ram/hardware.mk
endif

# Sources
VSRC+=$(AFIFO_ASYM_DIR)/iob_async_fifo_asym.v
VSRC+=$(FIFO_DIR)/gray2bin.v
