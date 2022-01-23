defmacro:=-D
incdir:=-I
include config.mk

MEM_DIR=.

# Default module
MEM_NAME ?= iob_ram_sp
MODULE_DIR = $(shell find . -name $(MEM_NAME))

# sources 
include $(MODULE_DIR)/hardware.mk

# INCLUDES
INCLUDE+=$(incdir)$(LIB_DIR)/hardware/include

# DEFINES
ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif

# testbench
VSRC+=$(wildcard $(MODULE_DIR)/$(MEM_NAME)_tb.v)

# Rules
.PHONY: sim sim-all clean corename $(ALL_MODULES)

#
# Simulate
#

# Icarus Verilog simulator flags
VLOG=iverilog -W all -g2005-sv $(INCLUDE) $(DEFINE)

sim: $(VSRC) $(VHDR)
	@echo $(VSRC)
	$(VLOG) $(VSRC)
	@echo "\n\nTesting module $(MEM_NAME)\n\n"
	@./a.out
ifeq ($(VCD),1)
	@if [ ! `pgrep gtkwave` ]; then gtkwave uut.vcd; fi &
endif

sim-waves: uut.vcd
	gtkwave uut.vcd &

uut.vcd:
	make sim VCD=1


ALL_MODULES=$(shell find . -name hardware.mk | sed 's/\/hardware.mk//g' | tail -n +3)

sim-all: $(ALL_MODULES)
	@echo "Listing all modules: $(ALL_MODULES)"

$(ALL_MODULES):
	make sim MEM_NAME=$(shell basename $@)

#
# DEBUG
#

debug:
	@echo $(MODULE_DIR)
	@echo $(VSRC)
	@echo $(MODULES)

#
# Clean
# 

clean:
	@rm -f *~ \#*\# a.out *.vcd *.drom *.png *.pyc


#
# Module name
#

corename:
	@echo "MEM"

