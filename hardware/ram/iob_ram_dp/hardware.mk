ifneq ($(ASIC),1)
ifneq (iob_ram_dp,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_dp

# Paths
DPRAM_DIR=$(MEM_RAM_DIR)/iob_ram_dp

# Sources
VSRC+=$(DPRAM_DIR)/iob_ram_dp.v

endif
endif
