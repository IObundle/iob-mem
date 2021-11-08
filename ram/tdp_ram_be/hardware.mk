include $(MEM_DIR)/mem.mk

# Submodules
include $(TDPRAM_DIR)/hardware.mk

# Sources
ifneq (TDPRAM_BE,$(filter TDPRAM_BE, $(SUBMODULES)))
SUBMODULES+=TDPRAM_BE
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v
endif
