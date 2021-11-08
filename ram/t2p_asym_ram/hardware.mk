include $(MEM_DIR)/mem.mk

# Submodules
include $(T2PRAM_DIR)/hardware.mk

# Sources
ifneq (T2P_ASYM_RAM,$(filter T2P_ASYM_RAM, $(SUBMODULES)))
SUBMODULES+=T2P_ASYM_RAM
VSRC+=$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_w_narrow_r_wide.v \
$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram_w_wide_r_narrow.v
endif
