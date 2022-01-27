ifneq ($(ASIC),1)
ifneq (iob_ram_tdp,$(filter iob_ram_tdp,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_ram_tdp

# Paths
TDPRAM_DIR=$(MEM_RAM_DIR)/iob_ram_tdp

# Sources
VSRC+=$(TDPRAM_DIR)/iob_ram_tdp.v

endif
endif
