include config.mk

#define module name here from directory below the hardware directory
MEM_NAME="t2p_asym_ram"

#add to define list
DEFINE+=$(defmacro)MEM_NAME=$(MEM_MODULE_NAME)


#add to global modules list
MODULES+=$(MEM_MODULE_NAME)

# Paths
T2P_ASYM_RAM_DIR=$(MEM_HW_DIR)/ram/t2p_asym_ram

# Submodules
ifneq (ram/t2p_ram,$(filter ram/t2p_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/t2p_ram/hardware.mk
endif

# Sources
VSRC+=$(T2P_ASYM_RAM_DIR)/iob_t2p_asym_ram.v
