# Submodules
include $(MEM_HW_DIR)/ram/t2p_ram/hardware.mk

# Sources
T2P_ASYM_RAM_DIR=$(MEM_HW_DIR)/ram/t2p_asym_ram
VSRC+=$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_w_narrow_r_wide.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_w_wide_r_narrow.v
