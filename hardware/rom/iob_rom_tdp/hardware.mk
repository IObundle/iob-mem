ifneq ($(ASIC),1)
ifneq (iob_rom_tdp,$(filter iob_rom_tdp,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_rom_tdp

# Paths
TDPROM_DIR=$(MEM_ROM_DIR)/iob_rom_tdp

# Sources
VSRC+=$(TDPROM_DIR)/iob_rom_tdp.v

endif
endif
