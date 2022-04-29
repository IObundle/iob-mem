ifneq ($(ASIC),1)
ifeq ($(filter iob_rom_tdp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_rom_tdp

# Sources
VSRC+=$(MEM_DIR)/hardware/rom/iob_rom_tdp/iob_rom_tdp.v

endif
endif
