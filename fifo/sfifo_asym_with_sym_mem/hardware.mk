include $(MEM_DIR)/core.mk

# Submodules
include $(RAM_DIR)/dp_ram/hardware.mk

ifneq (BIN_COUNTER,$(filter BIN_COUNTER, $(SUBMODULES)))
SUBMODULES+=BIN_COUNTER
BIN_COUNTER_DIR=$(FIFO_DIR)
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v
endif

# Sources
ifneq (SFIFO_ASYM_SMEM,$(filter SFIFO_ASYM_SMEM, $(SUBMODULES)))
SUBMODULES+=SFIFO_ASYM_SMEM
SFIFO_ASYM_SMEM_DIR=$(FIFO_DIR)/sfifo_asym_with_sym_mem
VSRC+=$(SFIFO_ASYM_SMEM_DIR)/iob_sync_fifo_asym_smem.v \
$(SFIFO_ASYM_SMEM_DIR)/iob_sync_fifo_asym_smem_r_big.v \
$(SFIFO_ASYM_SMEM_DIR)/iob_sync_fifo_asym_smem_w_big.v
endif
