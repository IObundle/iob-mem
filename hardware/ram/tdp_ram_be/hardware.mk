include $(MEM_DIR)/config.mk

MEM_NAME:=ram/tdp_ram_be

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
TDPRAM_BE_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Submodules
include $(MEM_HW_DIR)/ram/tdp_ram/hardware.mk

# Sources
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v

endif
endif
