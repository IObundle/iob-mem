ifneq ($(ASIC),1)
ifneq (iob_rom_sp,$(filter iob_rom_sp,, $(MODULES)))

# Add to modules list
MODULES+=iob_rom_sp

# Paths
SPROM_DIR=$(MEM_ROM_DIR)/iob_rom_sp

# Sources
VSRC+=$(SPROM_DIR)/iob_rom_sp.v

endif
endif
