ifneq ($(ASIC),1)
ifneq (iob_ram_2p,$(filter $S, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_ram_2p

# Paths
2PRAM_DIR=$(MEM_RAM_DIR)/iob_ram_2p

# Sources
VSRC+=$(2PRAM_DIR)/iob_ram_2p.v

endif
endif
