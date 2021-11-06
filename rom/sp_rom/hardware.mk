include $(MEM_DIR)/core.mk

# Sources
ifneq (SPROM,$(filter SPROM, $(SUBMODULES)))
SUBMODULES+=SPROM
SPROM_DIR=$(ROM_DIR)/sp_rom
VSRC+=$(SPROM_DIR)/iob_sp_rom.v
endif
