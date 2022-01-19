ifneq ($(ASIC),1)
ifneq (iob_reg_file_dp,$(filter iob_reg_file_dp,, $(MODULES)))

# Add to modules list
MODULES+=iob_reg_file_dp

# Paths
DP_REGFILE_DIR=$(MEM_REGF_DIR)/iob_reg_file_dp

# Sources
VSRC+=$(DP_REGFILE_DIR)/iob_reg_file_dp.v

endif
endif
