include $(MEM_DIR)/mem.mk

# Submodules
include $(2P_ASYM_RAM_DIR)/hardware.mk

# Sources
ifneq (2P_ASYM_RAM_TILED,$(filter 2P_ASYM_RAM_TILED, $(SUBMODULES)))
SUBMODULES+=2P_ASYM_RAM_TILED
VSRC+=$(2P_ASYM_RAM_TILED_DIR)/iob_2p_asym_ram_tiled.v
endif
