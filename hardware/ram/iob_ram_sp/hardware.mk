ifneq ($(ASIC),1)
ifneq (iob_ram_sp,$(filter iob_ram_sp,, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_sp

# Paths
SPRAM_DIR=$(MEM_RAM_DIR)/iob_ram_sp

# Sources
VSRC+=$(SPRAM_DIR)/iob_ram_sp.v

endif
endif
