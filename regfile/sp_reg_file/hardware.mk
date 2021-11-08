# Sources
ifneq (SP_REGFILE,$(filter SP_REGFILE, $(SUBMODULES)))
SUBMODULES+=SP_REGFILE
SP_REGFILE_DIR=$(MEM_DIR)/regfile/sp_reg_file
VSRC+=$(SP_REGFILE_DIR)/iob_sp_reg_file.v
endif
