include $(MEM_DIR)/config.mk

MEM_NAME:=ram/2p_ram

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
2PRAM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(2PRAM_DIR)/iob_2p_ram.v

endif
endif
