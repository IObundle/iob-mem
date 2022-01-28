ifneq ($(ASIC),1)
ifneq (iob_ram_dp_be,$(filter iob_ram_dp_be,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=iob_ram_dp_be

# Submodules
include $(MEM_DIR)/hardware/ram/iob_ram_dp/hardware.mk

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_dp_be/iob_ram_dp_be.v

endif
endif
