ifneq ($(ASIC),1)
ifeq ($(filter iob_rom_sp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_rom_sp

# Sources
VSRC+=$(MEM_DIR)/hardware/rom/iob_rom_sp/iob_rom_sp.v

endif
endif
