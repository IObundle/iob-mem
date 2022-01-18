include $(MEM_DIR)/config.mk

MEM_NAME:=ram/sp_ram

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
SPRAM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(SPRAM_DIR)/iob_sp_ram.v

endif
endif
