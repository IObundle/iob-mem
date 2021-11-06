include $(MEM_DIR)/core.mk

# Sources
ifneq (SPRAM,$(filter SPRAM, $(SUBMODULES)))
SUBMODULES+=SPRAM
SPRAM_DIR=$(RAM_DIR)/sp_ram
VSRC+=$(SPRAM_DIR)/iob_sp_ram.v
endif
