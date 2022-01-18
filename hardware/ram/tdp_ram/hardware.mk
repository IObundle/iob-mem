include $(MEM_DIR)/config.mk

MEM_NAME:=ram/tdp_ram

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
TDPRAM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(TDPRAM_DIR)/iob_tdp_ram.v

endif
endif
