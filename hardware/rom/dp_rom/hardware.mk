include $(MEM_DIR)/config.mk

MEM_NAME:=rom/dp_rom

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
DPROM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(DPROM_DIR)/iob_dp_rom.v

endif
endif
