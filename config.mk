# generate .vcd file by default
VCD ?=1

# optional ram
USE_RAM ?=1

#
# Paths
#

MEM_HW_DIR=$(MEM_DIR)/hardware
MEM_SW_DIR=$(MEM_DIR)/software
MEM_PYTHON_DIR=$(SW_DIR)/python

# Default module to simulate
MODULE_DIR ?= $(MEM_HW_DIR)/ram/sp_ram
