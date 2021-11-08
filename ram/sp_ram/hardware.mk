include $(MEM_DIR)/mem.mk

# Sources
ifneq (SPRAM,$(filter SPRAM, $(SUBMODULES)))
SUBMODULES+=SPRAM
VSRC+=$(SPRAM_DIR)/iob_sp_ram.v
endif
