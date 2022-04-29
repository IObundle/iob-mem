ifneq ($(ASIC),1)
ifeq ($(filter iob_regfile_dp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_regfile_dp

# Sources
VSRC+=$(MEM_DIR)/hardware/regfile/iob_regfile_dp/iob_regfile_dp.v

endif
endif
