# Submodules
include $(MEM_HW_DIR)/ram/tdp_ram/hardware.mk

# Sources
ifneq ($(ASIC),1)
ifneq (TDPRAM_BE,$(filter TDPRAM_BE, $(SUBMODULES)))
SUBMODULES+=TDPRAM_BE
TDPRAM_BE_DIR=$(MEM_HW_DIR)/ram/tdp_ram_be
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v
endif
endif
