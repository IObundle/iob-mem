ifneq ($(ASIC),1)

include $(MEM_DIR)/config.mk

# Paths
2PRAM_DIR=$(MEM_HW_DIR)/ram/2p_ram

# Sources
VSRC+=$(2PRAM_DIR)/iob_2p_ram.v

endif
