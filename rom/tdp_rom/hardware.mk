include $(MEM_DIR)/core.mk

# Sources
ifneq (TDPROM,$(filter TDPROM, $(SUBMODULES)))
SUBMODULES+=TDPROM
TDPROM_DIR=$(ROM_DIR)/tdp_rom
VSRC+=$(TDPROM_DIR)/iob_tdp_rom.v
endif
