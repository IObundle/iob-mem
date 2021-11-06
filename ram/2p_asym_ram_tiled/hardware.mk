include $(MEM_DIR)/core.mk

# Submodules
ifneq (2P_ASYM_RAM,$(filter 2P_ASYM_RAM, $(SUBMODULES)))
SUBMODULES+=2P_ASYM_RAM
2P_ASYM_RAM_DIR=$(RAM_DIR)/2p_asym_ram
VSRC+=$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram.v \
$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram_r_big.v \
$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram_w_big.v
endif

# Sources
ifneq (2P_ASYM_RAM_TILED,$(filter 2P_ASYM_RAM_TILED, $(SUBMODULES)))
SUBMODULES+=2P_ASYM_RAM_TILED
2P_ASYM_RAM_TILED_DIR=$(RAM_DIR)/2p_asym_ram_tiled
VSRC+=$(2P_ASYM_RAM_TILED_DIR)/iob_2p_asym_ram_tiled.v
endif
