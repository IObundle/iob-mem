include $(MEM_DIR)/config.mk

MEM_NAME:=rom/tdp_rom

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
TDPROM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(TDPROM_DIR)/iob_tdp_rom.v

endif
endif
