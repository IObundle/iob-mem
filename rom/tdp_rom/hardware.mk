# Sources
ifneq ($(ASIC),1)
ifneq (TDPROM,$(filter TDPROM, $(SUBMODULES)))
SUBMODULES+=TDPROM
TDPROM_DIR=$(MEM_DIR)/rom/tdp_rom
VSRC+=$(TDPROM_DIR)/iob_tdp_rom.v
endif
endif
