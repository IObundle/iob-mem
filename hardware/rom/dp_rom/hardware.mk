# Sources
ifneq ($(ASIC),1)
DPROM_DIR=$(MEM_HW_DIR)/rom/dp_rom
VSRC+=$(DPROM_DIR)/iob_dp_rom.v
endif
endif
