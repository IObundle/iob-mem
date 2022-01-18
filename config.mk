# PATHS

LIB_DIR?=submodules/LIB

MEM_HW_DIR?=$(MEM_DIR)/hardware
MEM_SW_DIR?=$(MEM_DIR)/software
MEM_PYTHON_DIR?=$(SW_DIR)/python

INCLUDE += $(incdir)$(LIB_DIR)/hardware/include

#SIMULATION

# Default module to simulate
MEM_NAME ?= sp_ram

# do not generate .vcd file by default
VCD ?=0

