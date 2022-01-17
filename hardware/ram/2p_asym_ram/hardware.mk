MODULES+=ram/2p_asym_ram

# Paths
2P_ASYM_RAM_DIR=$(MEM_HW_DIR)/ram/2p_asym_ram

# Submodules
ifneq (ram/2p_ram,$(filter ram/2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/2p_ram/hardware.mk
endif

# Sources
VSRC+=$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram.v
