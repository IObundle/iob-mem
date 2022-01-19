ifneq (gray_counter,$(filter $S, $(MODULES)))

# Add to modules list
MODULES+=gray_counter

# Paths
GRAY_COUNTER_DIR=$(MEM_FIFO_DIR)/gray_counter

# Sources
VSRC+=$(GRAY_COUNTER_DIR)/gray_counter.v

endif
