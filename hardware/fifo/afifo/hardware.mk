MODULES+=fifo/afifo

# Paths
AFIFO_DIR=$(MEM_HW_DIR)/fifo/afifo

# Submodules
ifneq (ram/t2p_ram,$(filter ram/t2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/t2p_ram/hardware.mk
endif

# Sources
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v
