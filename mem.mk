#
# Paths
#

MEM_SW_DIR ?=$(MEM_DIR)/software
MEM_PYTHON_DIR ?=$(SW_DIR)/python

#
# Submodules
#

# RAMs
RAM_DIR ?=$(MEM_DIR)/ram
2P_ASYM_RAM_DIR ?=$(RAM_DIR)/2p_asym_ram
2P_ASYM_RAM_TILED_DIR ?=$(RAM_DIR)/2p_asym_ram_tiled
2PRAM_DIR ?=$(RAM_DIR)/2p_ram
2PRAM_TILED_DIR ?=$(RAM_DIR)/2p_ram_tiled
DPRAM_DIR ?=$(RAM_DIR)/dp_ram
DPRAM_BE_DIR ?=$(RAM_DIR)/dp_ram_be
SPRAM_DIR ?=$(RAM_DIR)/sp_ram
SPRAM_BE_DIR ?=$(RAM_DIR)/sp_ram_be
T2P_ASYM_RAM_DIR ?=$(RAM_DIR)/t2p_asym_ram
T2PRAM_DIR ?=$(RAM_DIR)/t2p_ram
TDPRAM_DIR ?=$(RAM_DIR)/tdp_ram
TDPRAM_BE_DIR ?=$(RAM_DIR)/tdp_ram_be

# ROMs
ROM_DIR ?=$(MEM_DIR)/rom
SPROM_DIR ?=$(ROM_DIR)/sp_rom
TDPROM_DIR ?=$(ROM_DIR)/tdp_rom

# FIFOs
FIFO_DIR ?=$(MEM_DIR)/fifo
AFIFO_DIR ?=$(FIFO_DIR)/afifo
AFIFO_ASYM_DIR ?=$(FIFO_DIR)/afifo_asym
SFIFO_DIR ?=$(FIFO_DIR)/sfifo
FIFO_ASYM_DIR ?=$(FIFO_DIR)/sfifo_asym
SFIFO_ASYM_SMEM_DIR ?=$(FIFO_DIR)/sfifo_asym_with_sym_mem
BIN_COUNTER_DIR ?=$(FIFO_DIR)

# Register files
REGFILE_DIR ?=$(MEM_DIR)/regfile
DP_REGFILE_DIR ?=$(REGFILE_DIR)/dp_reg_file
SP_REGFILE_DIR ?=$(REGFILE_DIR)/sp_reg_file
