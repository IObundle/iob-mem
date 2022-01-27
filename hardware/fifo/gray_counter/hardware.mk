ifneq (gray_counter,$(filter gray_counter,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=gray_counter

# Sources
VSRC+=$(MEM_DIR)/hardware/fifo/gray_counter/gray_counter.v

endif
