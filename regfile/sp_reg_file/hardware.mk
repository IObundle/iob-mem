include $(MEM_DIR)/core.mk

# Sources
ifneq (SP_REGFILE,$(filter SP_REGFILE, $(SUBMODULES)))
SUBMODULES+=SP_REGFILE
VSRC+=$(SP_REGFILE_DIR)/iob_sp_reg_file.v
endif
