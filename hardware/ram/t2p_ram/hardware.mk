ifneq ($(ASIC),1)

MODULES+=ram/t2p_ram

# Paths
T2PRAM_DIR=$(MEM_HW_DIR)/ram/t2p_ram

# Sources
VSRC+=$(T2PRAM_DIR)/iob_t2p_ram.v

endif
