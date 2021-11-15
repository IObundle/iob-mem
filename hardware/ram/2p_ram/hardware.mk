# Sources
ifneq ($(ASIC),1)
2PRAM_DIR=$(MEM_HW_DIR)/ram/2p_ram
VSRC+=$(2PRAM_DIR)/iob_2p_ram.v
endif
endif
