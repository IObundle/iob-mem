include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/tdp_ram/hardware.mk

# Sources
ifneq (TDPRAM_BE,$(filter TDPRAM_BE, $(SUBMODULES)))
SUBMODULES+=TDPRAM_BE
TDPRAM_BE_DIR=$(RAM_DIR)/tdp_ram_be
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v
endif
