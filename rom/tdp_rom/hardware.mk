include $(MEM_DIR)/mem.mk

# Sources
ifneq (TDPROM,$(filter TDPROM, $(SUBMODULES)))
SUBMODULES+=TDPROM
VSRC+=$(TDPROM_DIR)/iob_tdp_rom.v
endif