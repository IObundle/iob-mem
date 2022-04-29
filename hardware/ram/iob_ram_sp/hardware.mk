ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_sp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_sp

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_sp/iob_ram_sp.v

endif
endif
