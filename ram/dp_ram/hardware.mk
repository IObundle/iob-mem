# Sources
ifneq (DPRAM,$(filter DPRAM, $(SUBMODULES)))
SUBMODULES+=DPRAM
DPRAM_DIR=$(MEM_DIR)/ram/dp_ram
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v
endif
