ifneq ($(ASIC),1)

MODULES+=rom/tdp_rom

# Paths
TDPROM_DIR=$(MEM_HW_DIR)/rom/tdp_rom

# Sources
VSRC+=$(TDPROM_DIR)/iob_tdp_rom.v

endif
