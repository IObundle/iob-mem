include $(MEM_DIR)/config.mk

MEM_NAME:=ram/t2p_ram

ifneq ($(ASIC),1)
ifneq ($(MEM_NAME),$(filter $(MEM_NAME), $(MODULES)))

MODULES+=$(MEM_NAME)

# Paths
T2PRAM_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# Sources
VSRC+=$(T2PRAM_DIR)/iob_t2p_ram.v

endif
endif
