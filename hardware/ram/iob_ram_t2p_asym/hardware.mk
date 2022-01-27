ifneq ($(ASIC),1)
ifneq (iob_ram_t2p_asym,$(filter iob_ram_t2p_asym,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_ram_t2p_asym

# Submodules
include $(LIB_DIR)/hardware/hardware.mk
include $(MEM_RAM_DIR)/iob_ram_t2p/hardware.mk

# Sources
VSRC+=$(MEM_RAM_DIR)/iob_ram_t2p_asym/iob_ram_t2p_asym.v

endif
endif
