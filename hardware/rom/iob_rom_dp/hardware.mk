ifneq ($(ASIC),1)
ifeq ($(filter iob_rom_dp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_rom_dp

# Sources
VSRC+=$(MEM_DIR)/hardware/rom/iob_rom_dp/iob_rom_dp.v

endif
endif
