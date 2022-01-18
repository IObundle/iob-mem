ifneq ($(ASIC),1)

include $(MEM_DIR)/config.mk

# Paths
TDPRAM_BE_DIR=$(MEM_HW_DIR)/ram/tdp_ram_be

# Submodules
ifneq (ram/tdp_ram,$(filter ram/tdp_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/tdp_ram/hardware.mk
endif

# Sources
VSRC+=$(TDPRAM_BE_DIR)/iob_tdp_ram_be.v

endif
