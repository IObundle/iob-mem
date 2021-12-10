# Submodules
include $(MEM_HW_DIR)/ram/tdp_ram/hardware.mk

# Sources
ifneq ($(ASIC),1)
TDPRAM_BE_DIR=$(MEM_HW_DIR)/ram/tdp_ram_be
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v
endif
