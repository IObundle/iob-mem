# Sources
ifneq ($(ASIC),1)
DPRAM_DIR=$(MEM_HW_DIR)/ram/dp_ram
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v
endif
