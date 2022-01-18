include $(MEM_DIR)/config.mk

MEM_NAME:=ram/sp_ram_be

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
SPRAM_BE_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Submodules
include $(MEM_HW_DIR)/ram/sp_ram/hardware.mk

# Sources
VSRC+=$(SPRAM_BE_DIR)/iob_sp_ram_be.v

endif
endif
