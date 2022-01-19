# PATHS
LIB_DIR ?=submodules/LIB
MEM_HW_DIR ?=$(MEM_DIR)/hardware
MEM_FIFO_DIR ?=$(MEM_HW_DIR)/fifo
MEM_RAM_DIR ?=$(MEM_HW_DIR)/ram
MEM_ROM_DIR ?=$(MEM_HW_DIR)/rom
MEM_REGF_DIR ?=$(MEM_HW_DIR)/regfile
MEM_SW_DIR ?=$(MEM_DIR)/software
MEM_PYTHON_DIR ?=$(SW_DIR)/python

# INCLUDES
INCLUDE+=$(incdir)$(LIB_DIR)/hardware/include

# DEFINES
ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif
