MODULES+=$(MEM_NAME)

#
# Paths
#

MEM_HW_DIR=$(MEM_DIR)/hardware
MEM_SW_DIR=$(MEM_DIR)/software
MEM_PYTHON_DIR=$(SW_DIR)/python

#
# Simulation
#

# Default module to simulate
MODULE_DIR=$(MEM_HW_DIR)/$(MEM_NAME)

# do not generate .vcd file by default
VCD ?=0
