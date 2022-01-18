include $(MEM_DIR)/config.mk

MEM_NAME:=ram/dp_ram_be

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
DPRAM_BE_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Submodules
include $(MEM_HW_DIR)/ram/dp_ram/hardware.mk

# Sources
VSRC+=$(DPRAM_BE_DIR)/iob_dp_ram_be.v

endif
endif
