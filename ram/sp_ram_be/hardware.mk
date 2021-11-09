# Submodules
include $(MEM_DIR)/ram/sp_ram/hardware.mk

# Sources
ifneq ($(ASIC),1)
ifneq (SPRAM_BE,$(filter SPRAM_BE, $(SUBMODULES)))
SUBMODULES+=SPRAM_BE
SPRAM_BE_DIR=$(MEM_DIR)/ram/sp_ram_be
VSRC+=$(SPRAM_BE_DIR)/iob_sp_ram_be.v
endif
endif
