ifneq ($(ASIC),1)

include $(MEM_DIR)/config.mk

# Paths
SPRAM_DIR=$(MEM_HW_DIR)/ram/sp_ram

# Sources
VSRC+=$(SPRAM_DIR)/iob_sp_ram.v

endif
