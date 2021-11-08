# Submodules
include $(MEM_DIR)/ram/t2p_ram/hardware.mk

# Sources
ifneq (T2P_ASYM_RAM,$(filter T2P_ASYM_RAM, $(SUBMODULES)))
SUBMODULES+=T2P_ASYM_RAM
T2P_ASYM_RAM_DIR=$(MEM_DIR)/ram/t2p_asym_ram
VSRC+=$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_w_narrow_r_wide.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_w_wide_r_narrow.v
endif
