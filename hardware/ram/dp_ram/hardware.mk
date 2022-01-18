include $(MEM_DIR)/config.mk

MEM_NAME:=ram/dp_ram

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
DPRAM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v

endif
endif
