include $(MEM_DIR)/core.mk

# Submodules
ifneq (TDPRAM,$(filter TDPRAM, $(SUBMODULES)))
SUBMODULES+=TDPRAM
TDPRAM_DIR=$(RAM_DIR)/tdp_ram
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v
endif

# Sources
ifneq (TDPRAM_BE,$(filter TDPRAM_BE, $(SUBMODULES)))
SUBMODULES+=TDPRAM_BE
TDPRAM_BE_DIR=$(RAM_DIR)/tdp_ram_be
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v
endif
