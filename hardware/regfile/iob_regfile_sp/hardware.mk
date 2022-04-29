ifneq ($(ASIC),1)
ifeq ($(filter iob_regfile_sp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_regfile_sp

# Sources
VSRC+=$(MEM_DIR)/hardware/regfile/iob_regfile_sp/iob_regfile_sp.v

endif
endif
