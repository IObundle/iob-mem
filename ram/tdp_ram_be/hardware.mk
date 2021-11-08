# Submodules
include $(MEM_DIR)/ram/tdp_ram/hardware.mk

# Sources
ifneq (TDPRAM_BE,$(filter TDPRAM_BE, $(SUBMODULES)))
SUBMODULES+=TDPRAM_BE
TDPRAM_BE_DIR=$(MEM_DIR)/ram/tdp_ram_be
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v
endif
