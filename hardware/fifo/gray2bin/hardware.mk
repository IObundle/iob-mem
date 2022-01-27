ifneq (gray2bin,$(filter gray2bin,, $(HW_MODULES)))

# Add to modules list
HW_MODULES+=gray2bin

# Sources
VSRC+=$(MEM_DIR)/hardware/fifo/gray2bin/gray2bin.v

endif
