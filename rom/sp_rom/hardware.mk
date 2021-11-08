include $(MEM_DIR)/mem.mk

# Sources
ifneq (SPROM,$(filter SPROM, $(SUBMODULES)))
SUBMODULES+=SPROM
VSRC+=$(SPROM_DIR)/iob_sp_rom.v
endif
