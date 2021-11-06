include $(MEM_DIR)/core.mk

# Sources
ifneq (AFIFO,$(filter AFIFO, $(SUBMODULES)))
SUBMODULES+=AFIFO
AFIFO_DIR=$(FIFO_DIR)/afifo
VSRC+=$(AFIFO_DIR)/iob_async_fifo.v
endif
