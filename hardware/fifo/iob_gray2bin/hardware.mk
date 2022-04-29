ifeq ($(filter iob_gray2bin, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_gray2bin

# Sources
VSRC+=$(MEM_DIR)/hardware/fifo/iob_gray2bin/iob_gray2bin.v

endif
