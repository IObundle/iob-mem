# Submodules
include $(MEM_HW_DIR)/ram/sp_ram/hardware.mk

# Sources
ifneq ($(ASIC),1)
SPRAM_BE_DIR=$(MEM_HW_DIR)/ram/sp_ram_be
VSRC+=$(SPRAM_BE_DIR)/iob_sp_ram_be.v
endif
