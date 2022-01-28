ifneq ($(ASIC),1)
ifneq (iob_ram_2p,$(filter $S, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_ram_2p

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_2p/iob_ram_2p.v

endif
endif
