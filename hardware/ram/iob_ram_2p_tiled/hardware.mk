ifneq ($(ASIC),1)
ifneq (iob_ram_2p_tiled,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_2p_tiled

# Paths
2PRAM_TILED_DIR=$(MEM_RAM_DIR)/iob_ram_2p_tiled

# Submodules
include $(MEM_RAM_DIR)/iob_ram_2p/hardware.mk

# Sources
VSRC+=$(2PRAM_TILED_DIR)/iob_ram_2p_tiled.v

endif
endif