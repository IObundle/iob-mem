ifneq (iob_ram_t2p_asym,$(filter $S, $(MODULES)))

# Sources
VSRC+=$(MEM_DIR)/hardware/ram/iob_ram_t2p_asym/iob_ram_t2p_asym.v

# Add to modules list
MODULES+=iob_ram_t2p_asym

# Submodules
include $(MEM_DIR)/hardware/ram/iob_ram_t2p/hardware.mk

endif
