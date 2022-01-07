MODULES+=ram/2p_ram_tiled

# Paths
2PRAM_TILED_DIR=$(MEM_HW_DIR)/ram/2p_ram_tiled

# Submodules
ifneq (ram/2p_ram,$(filter ram/2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/2p_ram/hardware.mk
endif

# Sources
VSRC+=$(2PRAM_TILED_DIR)/iob_2p_ram_tiled.v
