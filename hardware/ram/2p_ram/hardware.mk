ifneq ($(ASIC),1)

MODULES+=ram/2p_ram

# Paths
2PRAM_DIR=$(MEM_HW_DIR)/ram/2p_ram

# Sources
VSRC+=$(2PRAM_DIR)/iob_2p_ram.v

endif
