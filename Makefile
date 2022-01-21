defmacro:=-D
incdir:=-I
include config.mk

MEM_DIR=.

# Default module
MEM_NAME ?= iob_ram_sp
MODULE_DIR = $(shell find . -name $(MEM_NAME))

# sources 
include $(MODULE_DIR)/hardware.mk

# testbench
VSRC+=$(wildcard $(MODULE_DIR)/$(MEM_NAME)_tb.v)

# hex files generation for tb
# generate .hex file from string, checks from ram if string is valid
HEX_FILES:=data.hex
GEN_HEX:=echo "!IObundle 2020!" | od -A n -t x1 > data.hex

# Rules
.PHONY: sim sim-all clean corename $(ALL_MODULES)

#
# Simulate
#

# Icarus Verilog simulator flags
VLOG=iverilog -W all -g2005-sv $(INCLUDE) $(DEFINE)

sim: $(VSRC) $(VHDR) data.hex
	@echo $(VSRC)
	$(VLOG) $(VSRC)
	@echo "\n\nTesting module $(MEM_NAME)\n\n"
	@./a.out
ifeq ($(VCD),1)
	if [ ! `pgrep gtkwave` ]; then gtkwave uut.vcd; fi &
endif

$(HEX_FILES):
	@$(GEN_HEX)

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
	@rm -f *~ \#*\# a.out *.hex *.vcd *.drom *.png *.pyc


#
# Module name
#

corename:
	@echo "MEM"

