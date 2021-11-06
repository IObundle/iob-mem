include $(MEM_DIR)/core.mk

# Submodules
ifneq (TDPRAM,$(filter TDPRAM, $(SUBMODULES)))
SUBMODULES+=TDPRAM
TDPRAM_DIR=$(RAM_DIR)/tdp_ram
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v
endif
