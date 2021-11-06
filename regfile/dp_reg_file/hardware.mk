include $(MEM_DIR)/core.mk

# Sources
ifneq (DP_REGFILE,$(filter DP_REGFILE, $(SUBMODULES)))
SUBMODULES+=DP_REGFILE
DP_REGFILE_DIR=$(REGFILE_DIR)/dp_reg_file
VSRC+=$(DP_REGFILE_DIR)/iob_dp_reg_file.v
endif
