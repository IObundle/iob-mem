# Sources
ifneq ($(ASIC),1)
ifneq (DPROM,$(filter DPROM, $(SUBMODULES)))
SUBMODULES+=DPROM
DPROM_DIR=$(MEM_DIR)/rom/dp_rom
VSRC+=$(DPROM_DIR)/iob_dp_rom.v
endif
endif
