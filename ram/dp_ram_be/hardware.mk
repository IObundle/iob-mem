include $(MEM_DIR)/mem.mk

# Submodules
include $(DPRAM_DIR)/hardware.mk

# Sources
ifneq (DPRAM_BE,$(filter DPRAM_BE, $(SUBMODULES)))
SUBMODULES+=DPRAM_BE
VSRC+=$(DPRAM_BE_DIR)/iob_dp_ram_be.v
endif
