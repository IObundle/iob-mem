ifneq ($(ASIC),1)

include $(MEM_DIR)/config.mk

# Paths
DPRAM_BE_DIR=$(MEM_HW_DIR)/ram/dp_ram_be

# Submodules
ifneq (ram/dp_ram,$(filter ram/dp_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/dp_ram/hardware.mk
endif

# Sources
VSRC+=$(DPRAM_BE_DIR)/iob_dp_ram_be.v

endif
