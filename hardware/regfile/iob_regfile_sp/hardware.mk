ifneq ($(ASIC),1)
ifneq (iob_reg_file_sp,$(filter iob_reg_file_sp,, $(MODULES)))

# Add to modules list
MODULES+=iob_reg_file_sp

# Paths
SP_REGFILE_DIR=$(MEM_REGF_DIR)/iob_reg_file_sp

# Sources
VSRC+=$(SP_REGFILE_DIR)/iob_reg_file_sp.v

endif
endif
