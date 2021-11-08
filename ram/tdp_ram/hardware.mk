include $(MEM_DIR)/core.mk

# Submodules
ifneq (TDPRAM,$(filter TDPRAM, $(SUBMODULES)))
SUBMODULES+=TDPRAM
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v
endif
