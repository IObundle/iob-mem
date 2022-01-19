ifneq (bin_counter,$(filter bin_counter,, $(MODULES)))

# Add to modules list
MODULES+=bin_counter

# Paths
BIN_COUNTER_DIR=$(MEM_FIFO_DIR)/bin_counter

# Sources
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v

endif
