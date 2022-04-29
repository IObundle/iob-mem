ifeq ($(filter iob_gray_counter, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_gray_counter

# Sources
VSRC+=$(MEM_DIR)/hardware/fifo/iob_gray_counter/iob_gray_counter.v

endif
