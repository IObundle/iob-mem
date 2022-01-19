ifneq ($(ASIC),1)
ifneq (iob_ram_2p_asym,$(filter iob_ram_2p_asym,, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_2p_asym

# Paths
2P_ASYM_RAM_DIR=$(MEM_RAM_DIR)/iob_ram_2p_asym

# Submodules
include $(MEM_RAM_DIR)/iob_ram_2p/hardware.mk

# Sources
VSRC+=$(2P_ASYM_RAM_DIR)/iob_ram_2p_asym.v

endif
endif
