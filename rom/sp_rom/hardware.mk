include $(MEM_DIR)/core.mk

# Sources
ifneq (SPROM,$(filter SPROM, $(SUBMODULES)))
SUBMODULES+=SPROM
VSRC+=$(SPROM_DIR)/iob_sp_rom.v
endif
