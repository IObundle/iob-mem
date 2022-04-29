ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_t2p_asym, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_t2p_asym

# Submodules
include $(MEM_DIR)/hardware/ram/iob_ram_t2p/hardware.mk

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_t2p_asym/iob_ram_t2p_asym.v

endif
endif
