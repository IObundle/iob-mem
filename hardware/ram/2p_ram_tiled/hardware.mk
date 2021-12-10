# Submodules
include $(MEM_HW_DIR)/ram/2p_ram/hardware.mk

# Sources
2PRAM_TILED_DIR=$(MEM_HW_DIR)/ram/2p_ram_tiled
VSRC+=$(2PRAM_TILED_DIR)/iob_2p_ram_tiled.v
