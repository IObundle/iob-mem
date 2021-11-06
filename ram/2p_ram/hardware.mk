include $(MEM_DIR)/core.mk

# Sources
ifneq (2PRAM,$(filter 2PRAM, $(SUBMODULES)))
SUBMODULES+=2PRAM
2PRAM_DIR=$(RAM_DIR)/2p_ram
VSRC+=$(2PRAM_DIR)/iob_2p_ram.v
endif
