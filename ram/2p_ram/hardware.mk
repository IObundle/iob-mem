include $(MEM_DIR)/mem.mk

# Sources
ifneq (2PRAM,$(filter 2PRAM, $(SUBMODULES)))
SUBMODULES+=2PRAM
VSRC+=$(2PRAM_DIR)/iob_2p_ram.v
endif
