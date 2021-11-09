# Sources
ifneq ($(ASIC),1)
ifneq (SPRAM,$(filter SPRAM, $(SUBMODULES)))
SUBMODULES+=SPRAM
SPRAM_DIR=$(MEM_DIR)/ram/sp_ram
VSRC+=$(SPRAM_DIR)/iob_sp_ram.v
endif
endif
