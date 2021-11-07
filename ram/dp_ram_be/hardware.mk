include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/dp_ram/hardware.mk

# Sources
ifneq (DPRAM_BE,$(filter DPRAM_BE, $(SUBMODULES)))
SUBMODULES+=DPRAM_BE
DPRAM_BE_DIR=$(RAM_DIR)/dp_ram_be
VSRC+=$(DPRAM_BE_DIR)/iob_dp_ram_be.v
endif
