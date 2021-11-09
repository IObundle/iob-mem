# Sources
ifneq ($(ASIC),1)
ifneq (T2PRAM,$(filter T2PRAM, $(SUBMODULES)))
SUBMODULES+=T2PRAM
T2PRAM_DIR=$(MEM_DIR)/ram/t2p_ram
VSRC+=$(T2PRAM_DIR)/iob_t2p_ram.v
endif
endif
