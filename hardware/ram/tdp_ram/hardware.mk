ifneq ($(ASIC),1)

include $(MEM_DIR)/config.mk

# Paths
TDPRAM_DIR=$(MEM_HW_DIR)/ram/tdp_ram

# Sources
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v

endif
