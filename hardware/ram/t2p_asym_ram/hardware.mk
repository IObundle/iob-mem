# Submodules
ifneq (t2p_ram,$(filter t2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/t2p_ram/hardware.mk
endif

# Sources
VSRC+=$(MODULE_DIR)/iob_t2p_asym_ram.v

# Add to modules list
MODULES+=t2p_asym_ram

