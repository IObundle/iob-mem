ifneq ($(ASIC),1)
ifneq (iob_ram_t2p_asym,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=iob_ram_t2p_asym

# Submodules
include $(MEM_RAM_DIR)/iob_ram_t2p/hardware.mk

# Sources
VSRC+=$(MEM_RAM_DIR)/iob_ram_t2p_asym/iob_ram_t2p_asym.v

endif
endif
