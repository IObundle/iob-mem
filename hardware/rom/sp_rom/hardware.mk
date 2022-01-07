ifneq ($(ASIC),1)

MODULES+=rom/sp_rom

# Paths
SPROM_DIR=$(MEM_HW_DIR)/rom/sp_rom

# Sources
VSRC+=$(SPROM_DIR)/iob_sp_rom.v

endif
