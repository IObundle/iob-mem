ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_2p_tiled, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_2p_tiled

# Submodules
include $(MEM_DIR)/hardware/ram/iob_ram_2p/hardware.mk

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_2p_tiled/iob_ram_2p_tiled.v

endif
endif
