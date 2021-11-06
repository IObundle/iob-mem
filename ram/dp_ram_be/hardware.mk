include $(MEM_DIR)/core.mk

# Submodules
ifneq (DPRAM,$(filter DPRAM, $(SUBMODULES)))
SUBMODULES+=DPRAM
DPRAM_DIR=$(RAM_DIR)/dp_ram
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v
endif

# Sources
ifneq (DPRAM_BE,$(filter DPRAM_BE, $(SUBMODULES)))
SUBMODULES+=DPRAM_BE
DPRAM_BE_DIR=$(RAM_DIR)/dp_ram_be
VSRC+=$(DPRAM_BE_DIR)/iob_dp_ram_be.v
endif
