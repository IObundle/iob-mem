ifneq ($(ASIC),1)

MODULES+=rom/dp_rom

# Paths
DPROM_DIR=$(MEM_HW_DIR)/rom/dp_rom

# Sources
VSRC+=$(DPROM_DIR)/iob_dp_rom.v

endif
