ifneq (gray2bin,$(filter gray2bin, $(MODULES)))

# Sources
VSRC+=$(MEM_HW_DIR)/fifo/gray2bin/gray2bin.v

# Add to modules list
MODULES+=gray2bin

endif
