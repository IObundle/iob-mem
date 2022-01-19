ifneq ($(ASIC),1)
ifneq (iob_ram_sp_be,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_sp_be

# Paths
SPRAM_BE_DIR=$(MEM_RAM_DIR)/iob_ram_sp_be

# Submodules
include $(MEM_RAM_DIR)/iob_ram_sp/hardware.mk

# Sources
VSRC+=$(SPRAM_BE_DIR)/iob_ram_sp_be.v

endif
endif
