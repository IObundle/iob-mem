ifneq ($(ASIC),1)
ifneq (iob_ram_t2p,$(filter $S, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_ram_t2p

# Paths
T2PRAM_DIR=$(MEM_RAM_DIR)/iob_ram_t2p

# Sources
VSRC+=$(T2PRAM_DIR)/iob_ram_t2p.v

endif
endif
