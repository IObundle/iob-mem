include $(MEM_DIR)/core.mk

# Sources
ifneq (DPRAM,$(filter DPRAM, $(SUBMODULES)))
SUBMODULES+=DPRAM
DPRAM_DIR=$(RAM_DIR)/dp_ram
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v
endif
