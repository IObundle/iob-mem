ifneq ($(ASIC),1)
ifeq ($(filter iob_ram_dp, $(HW_MODULES)),)

# Add to modules list
HW_MODULES+=iob_ram_dp

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_dp/iob_ram_dp.v

endif
endif
