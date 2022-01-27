ifneq (gray_counter,$(filter gray_counter,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=gray_counter

# Paths
GRAY_COUNTER_DIR=$(MEM_FIFO_DIR)/gray_counter

# Sources
VSRC+=$(GRAY_COUNTER_DIR)/gray_counter.v

endif
