include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/t2p_ram/hardware.mk

# Sources
ifneq (T2P_ASYM_RAM,$(filter T2P_ASYM_RAM, $(SUBMODULES)))
SUBMODULES+=T2P_ASYM_RAM
T2P_ASYM_RAM_DIR=$(RAM_DIR)/t2p_asym_ram
VSRC+=$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_r_big.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_w_big.v
endif
