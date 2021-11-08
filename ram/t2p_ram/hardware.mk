include $(MEM_DIR)/core.mk

# Sources
ifneq (T2PRAM,$(filter T2PRAM, $(SUBMODULES)))
SUBMODULES+=T2PRAM
VSRC+=$(T2PRAM_DIR)/iob_t2p_ram.v
endif
