include $(MEM_DIR)/config.mk

MEM_NAME:=rom/sp_rom

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
SPROM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(SPROM_DIR)/iob_sp_rom.v

endif
endif
