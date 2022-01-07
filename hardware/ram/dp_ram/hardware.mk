ifneq ($(ASIC),1)

MODULES+=ram/dp_ram

# Paths
DPRAM_DIR=$(MEM_HW_DIR)/ram/dp_ram

# Sources
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v

endif
