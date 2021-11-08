include $(MEM_DIR)/core.mk

# Sources
ifneq (AFIFO,$(filter AFIFO, $(SUBMODULES)))
SUBMODULES+=AFIFO
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v
endif
