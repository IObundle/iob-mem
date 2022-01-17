# Paths

LIB_DIR?=submodules/LIB

MEM_HW_DIR?=hardware
MEM_SW_DIR?=software
MEM_PYTHON_DIR?=$(SW_DIR)/python

INCLUDE += $(incdir)$(LIB_DIR)/hardware/include

#SIMULATION

# Default module to simulate
MODULE_DIR ?= $(MEM_HW_DIR)/ram/sp_ram

# do not generate .vcd file by default
VCD ?=0

