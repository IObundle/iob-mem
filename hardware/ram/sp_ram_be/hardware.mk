ifneq ($(ASIC),1)

include $(MEM_DIR)/config.mk

# Paths
SPRAM_BE_DIR=$(MEM_HW_DIR)/ram/sp_ram_be

# Submodules
ifneq (ram/sp_ram,$(filter ram/sp_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/sp_ram/hardware.mk
endif

# Sources
VSRC+=$(SPRAM_BE_DIR)/iob_sp_ram_be.v

endif
