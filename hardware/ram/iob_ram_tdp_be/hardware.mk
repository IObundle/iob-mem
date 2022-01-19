ifneq ($(ASIC),1)
ifneq (iob_ram_tdp_be,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_tdp_be

# Paths
TDPRAM_BE_DIR=$(MEM_RAM_DIR)/iob_ram_tdp_be

# Submodules
include $(MEM_RAM_DIR)/iob_ram_tdp/hardware.mk

# Sources
VSRC+=$(TDPRAM_BE_DIR)/iob_ram_tdp_be.v

endif
endif
