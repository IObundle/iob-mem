include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/dp_ram/hardware.mk

# Sources
ifneq (2PRAM_TILED,$(filter 2PRAM_TILED, $(SUBMODULES)))
SUBMODULES+=2PRAM_TILED
2PRAM_TILED_DIR=$(RAM_DIR)/2p_ram_tiled
VSRC+=$(2PRAM_TILED_DIR)/iob_2p_ram_tiled.v
endif
