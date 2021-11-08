include $(MEM_DIR)/mem.mk

# Submodules
ifneq (TDPRAM,$(filter TDPRAM, $(SUBMODULES)))
SUBMODULES+=TDPRAM
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v
endif
