include $(MEM_DIR)/mem.mk

# Submodules
include $(DPRAM_DIR)/hardware.mk

# Sources
ifneq (2PRAM_TILED,$(filter 2PRAM_TILED, $(SUBMODULES)))
SUBMODULES+=2PRAM_TILED
VSRC+=$(2PRAM_TILED_DIR)/iob_2p_ram_tiled.v
endif
