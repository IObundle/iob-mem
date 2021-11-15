# Sources
ifneq ($(ASIC),1)
SPROM_DIR=$(MEM_HW_DIR)/rom/sp_rom
VSRC+=$(SPROM_DIR)/iob_sp_rom.v
endif
