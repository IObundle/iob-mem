# Sources
ifneq ($(ASIC),1)
T2PRAM_DIR=$(MEM_HW_DIR)/ram/t2p_ram
VSRC+=$(T2PRAM_DIR)/iob_t2p_ram.v
endif
