MODULES+=ram/2p_asym_ram_tiled

# Paths
2P_ASYM_RAM_TILED_DIR=$(MEM_HW_DIR)/ram/2p_asym_ram_tiled

# Submodules
ifneq (ram/2p_asym_ram,$(filter ram/2p_asym_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/2p_asym_ram/hardware.mk
endif

# Sources
VSRC+=$(2P_ASYM_RAM_TILED_DIR)/iob_2p_asym_ram_tiled.v
