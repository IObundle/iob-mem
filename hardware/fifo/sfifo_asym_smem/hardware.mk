# Submodules
include $(MEM_HW_DIR)/ram/2p_ram/hardware.mk

BIN_COUNTER_DIR=$(MEM_HW_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v

# Sources
SFIFO_ASYM_SMEM_HW_DIR=$(MEM_HW_DIR)/fifo/sfifo_asym_smem
VSRC+=$(SFIFO_ASYM_SMEM_HW_DIR)/iob_sync_fifo_asym_smem.v \
$(SFIFO_ASYM_SMEM_HW_DIR)/iob_sync_fifo_asym_smem_w_narrow_r_wide.v \
$(SFIFO_ASYM_SMEM_HW_DIR)/iob_sync_fifo_asym_smem_w_wide_r_narrow.v
