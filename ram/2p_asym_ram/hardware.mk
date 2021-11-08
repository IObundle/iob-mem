# Sources
ifneq (2P_ASYM_RAM,$(filter 2P_ASYM_RAM, $(SUBMODULES)))
SUBMODULES+=2P_ASYM_RAM
2P_ASYM_RAM_DIR=$(MEM_DIR)/ram/2p_asym_ram
VSRC+=$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram.v \
$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram_w_narrow_r_wide.v \
$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram_w_wide_r_narrow.v
endif
