ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_t2p, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_t2p

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_t2p/iob_ram_t2p.v

endif
endif
