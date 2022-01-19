ifneq ($(ASIC),1)
ifneq (iob_regfile_dp,$(filter iob_regfile_dp,, $(MODULES)))

# Add to modules list
MODULES+=iob_regfile_dp

# Paths
DP_REGFILE_DIR=$(MEM_REGF_DIR)/iob_regfile_dp

# Sources
VSRC+=$(DP_REGFILE_DIR)/iob_regfile_dp.v

endif
endif
