include $(MEM_DIR)/core.mk

# Sources
ifneq (DPRAM,$(filter DPRAM, $(SUBMODULES)))
SUBMODULES+=DPRAM
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v
endif
