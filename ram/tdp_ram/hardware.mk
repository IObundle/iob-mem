# Sources
ifneq ($(ASIC),1)
ifneq (TDPRAM,$(filter TDPRAM, $(SUBMODULES)))
SUBMODULES+=TDPRAM
TDPRAM_DIR=$(MEM_DIR)/ram/tdp_ram
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v
endif
endif
