defmacro:=-D
incdir:=-I

include config.mk

ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif

MEM_NAME ?= sp_ram
MODULE_DIR = $(shell find . -name $(MEM_NAME))

include $(MODULE_DIR)/hardware.mk

# testbench
VSRC+=$(wildcard $(MODULE_DIR)/*_tb.v)


# Icarus Verilog simulator flags

VLOG=iverilog -W all -g2005-sv $(INCLUDE) $(DEFINE)

ALL_MODULES=$(shell find . -name hardware.mk | sed 's/\/hardware.mk//g' | tail -n +2)

.PHONY: sim sim-all clean corename $(ALL_MODULES)

#
# Simulate
#

sim: $(VSRC) $(VHDR)
	$(VLOG) $(VSRC)
	@echo "\n\nTesting module $(MEM_NAME)\n\n"
	@./a.out
ifeq ($(VCD),1)
	if [ ! `pgrep gtkwave` ]; then gtkwave uut.vcd; fi &
endif


sim-all: $(ALL_MODULES)
	@echo "Listing all modules: $(ALL_MODULES)"

$(ALL_MODULES):
	make sim MODULE_DIR=$@


#
# Clean
# 

clean:
	@rm -f *~ \#*\# a.out *.vcd *.drom *.png *.pyc

corename:
	@echo "MEM"

