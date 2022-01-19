ifneq (gray2bin,$(filter gray2bin,, $(MODULES)))

# Add to modules list
MODULES+=gray2bin

# Paths
GRAY2BIN_DIR=$(MEM_FIFO_DIR)/gray2bin

# Sources
VSRC+=$(GRAY2BIN_DIR)/gray2bin.v

endif
