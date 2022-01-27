ifneq ($(ASIC),1)
ifneq (iob_ram_dp,$(filter iob_ram_dp,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_ram_dp

# Paths
DPRAM_DIR=$(MEM_RAM_DIR)/iob_ram_dp

# Sources
VSRC+=$(DPRAM_DIR)/iob_ram_dp.v

endif
endif
