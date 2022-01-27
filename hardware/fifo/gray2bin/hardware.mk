ifneq (gray2bin,$(filter gray2bin,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=gray2bin

# Paths
GRAY2BIN_DIR=$(MEM_FIFO_DIR)/gray2bin

# Sources
VSRC+=$(GRAY2BIN_DIR)/gray2bin.v

endif
