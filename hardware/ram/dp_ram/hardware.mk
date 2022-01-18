ifneq ($(ASIC),1)

include $(MEM_DIR)/config.mk

# Paths
DPRAM_DIR=$(MEM_HW_DIR)/ram/dp_ram

# Sources
VSRC+=$(DPRAM_DIR)/iob_dp_ram.v

endif
