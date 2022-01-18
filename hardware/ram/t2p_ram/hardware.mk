ifneq ($(ASIC),1)

# Sources
VSRC+=$(MEM_HW_DIR)/ram/t2p_ram/iob_t2p_ram.v

endif

# Add to modules list
MODULES+=t2p_ram
