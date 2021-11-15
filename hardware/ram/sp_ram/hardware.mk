# Sources
ifneq ($(ASIC),1)
SPRAM_DIR=$(MEM_HW_DIR)/ram/sp_ram
VSRC+=$(SPRAM_DIR)/iob_sp_ram.v
endif
