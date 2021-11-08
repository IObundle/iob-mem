# Submodules
include $(MEM_DIR)/ram/2p_ram/hardware.mk

ifneq (BIN_COUNTER,$(filter BIN_COUNTER, $(SUBMODULES)))
SUBMODULES+=BIN_COUNTER
BIN_COUNTER_DIR=$(MEM_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v
endif

# Sources
ifneq (SFIFO_ASYM_SMEM,$(filter SFIFO_ASYM_SMEM, $(SUBMODULES)))
SUBMODULES+=SFIFO_ASYM_SMEM
SFIFO_ASYM_SMEM_DIR=$(MEM_DIR)/fifo/sfifo_asym_smem
VSRC+=$(SFIFO_ASYM_SMEM_DIR)/iob_sync_fifo_asym_smem.v \
$(SFIFO_ASYM_SMEM_DIR)/iob_sync_fifo_asym_smem_w_narrow_r_wide.v \
$(SFIFO_ASYM_SMEM_DIR)/iob_sync_fifo_asym_smem_w_wide_r_narrow.v
endif
