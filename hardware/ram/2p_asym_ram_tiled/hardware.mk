# Submodules
include $(MEM_HW_DIR)/ram/2p_asym_ram/hardware.mk

# Sources
2P_ASYM_RAM_TILED_DIR=$(MEM_HW_DIR)/ram/2p_asym_ram_tiled
VSRC+=$(2P_ASYM_RAM_TILED_DIR)/iob_2p_asym_ram_tiled.v
endif
