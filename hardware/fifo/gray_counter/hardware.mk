ifneq (gray_counter,$(filter gray_counter, $(MODULES)))

# Sources
VSRC+=$(MEM_HW_DIR)/fifo/gray_counter/gray_counter.v

# Add to modules list
MODULES+=gray_counter

endif
