ifneq ($(ASIC),1)
ifneq (iob_regfile_sp,$(filter iob_regfile_sp,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_regfile_sp

# Paths
SP_REGFILE_DIR=$(MEM_REGF_DIR)/iob_regfile_sp

# Sources
VSRC+=$(SP_REGFILE_DIR)/iob_regfile_sp.v

endif
endif
