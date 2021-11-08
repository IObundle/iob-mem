include $(MEM_DIR)/mem.mk

# Sources
ifneq (2P_ASYM_RAM,$(filter 2P_ASYM_RAM, $(SUBMODULES)))
SUBMODULES+=2P_ASYM_RAM
VSRC+=$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram.v \
$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram_r_big.v \
$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram_w_big.v
endif
