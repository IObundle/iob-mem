ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_2p, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_2p

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_2p/iob_ram_2p.v

endif
endif
