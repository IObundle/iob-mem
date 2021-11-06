include $(MEM_DIR)/core.mk

# Submodules
ifneq (SPRAM,$(filter SPRAM, $(SUBMODULES)))
SUBMODULES+=SPRAM
SPRAM_DIR=$(RAM_DIR)/sp_ram
VSRC+=$(SPRAM_DIR)/iob_sp_ram.v
endif

# Sources
ifneq (SPRAM_BE,$(filter SPRAM_BE, $(SUBMODULES)))
SUBMODULES+=SPRAM_BE
SPRAM_BE_DIR=$(RAM_DIR)/sp_ram_be
VSRC+=$(SPRAM_BE_DIR)/iob_sp_ram_be.v
endif
