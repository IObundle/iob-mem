MODULES+=ram/t2p_asym_ram

# Paths
T2P_ASYM_RAM_DIR=$(MEM_HW_DIR)/ram/t2p_asym_ram

# Submodules
ifneq (ram/t2p_ram,$(filter ram/t2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/t2p_ram/hardware.mk
endif

# Sources
VSRC+=$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram.v
