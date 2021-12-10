# Sources
ifneq ($(ASIC),1)
TDPRAM_DIR=$(MEM_HW_DIR)/ram/tdp_ram
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v
endif
