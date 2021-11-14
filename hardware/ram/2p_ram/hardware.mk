# Sources
ifneq ($(ASIC),1)
ifneq (2PRAM,$(filter 2PRAM, $(SUBMODULES)))
SUBMODULES+=2PRAM
2PRAM_DIR=$(MEM_HW_DIR)/ram/2p_ram
VSRC+=$(2PRAM_DIR)/iob_2p_ram.v
endif
endif
