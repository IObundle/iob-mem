include $(MEM_DIR)/mem.mk

# Submodules
include $(SPRAM_DIR)/hardware.mk

# Sources
ifneq (SPRAM_BE,$(filter SPRAM_BE, $(SUBMODULES)))
SUBMODULES+=SPRAM_BE
VSRC+=$(SPRAM_BE_DIR)/iob_sp_ram_be.v
endif
