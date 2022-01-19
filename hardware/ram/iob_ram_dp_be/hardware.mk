ifneq ($(ASIC),1)
ifneq (iob_ram_dp_be,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_dp_be

# Paths
DPRAM_BE_DIR=$(MEM_RAM_DIR)/iob_ram_dp_be

# Submodules
include $(MEM_RAM_DIR)/iob_ram_dp/hardware.mk

# Sources
VSRC+=$(DPRAM_BE_DIR)/iob_ram_dp_be.v

endif
endif
