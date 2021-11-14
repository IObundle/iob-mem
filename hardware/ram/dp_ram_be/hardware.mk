# Submodules
include $(MEM_HW_DIR)/ram/dp_ram/hardware.mk

# Sources
ifneq ($(ASIC),1)
ifneq (DPRAM_BE,$(filter DPRAM_BE, $(SUBMODULES)))
SUBMODULES+=DPRAM_BE
DPRAM_BE_DIR=$(MEM_HW_DIR)/ram/dp_ram_be
VSRC+=$(DPRAM_BE_DIR)/iob_dp_ram_be.v
endif
endif
