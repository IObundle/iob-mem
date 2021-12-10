# Sources
ifneq ($(ASIC),1)
TDPROM_DIR=$(MEM_HW_DIR)/rom/tdp_rom
VSRC+=$(TDPROM_DIR)/iob_tdp_rom.v
endif
