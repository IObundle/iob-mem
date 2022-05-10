ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_tdp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_tdp

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_tdp/iob_ram_tdp.v

endif
endif
