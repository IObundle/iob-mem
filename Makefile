defmacro:=-D
incdir:=-I
include config.mk

MEM_DIR=.

# Default module
MEM_NAME ?= iob_ram_sp
MODULE_DIR = $(shell find . -name $(MEM_NAME))

# sources
include $(MODULE_DIR)/hardware.mk

# DEFINES
ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif

# testbench
VSRC+=$(wildcard $(MODULE_DIR)/$(MEM_NAME)_tb.v)

ALL_MODULES=$(shell find . -name hardware.mk -not -path './submodules/*' | sed 's/\/hardware.mk//g' | tail -n +3)

# Rules
.PHONY: sim sim-all clean $(ALL_MODULES)

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

test-sim: $(VSRC) $(VHDR)
	@echo $(VSRC)
	@echo "\n\nTesting module $(MEM_NAME)\n\n"
	$(VLOG) $(defmacro)W_DATA_W=32 $(defmacro)R_DATA_W=8 $(VSRC)
	@./a.out
	$(VLOG) $(defmacro)W_DATA_W=8 $(defmacro)R_DATA_W=32 $(VSRC)
	@./a.out
	$(VLOG) $(defmacro)W_DATA_W=8 $(defmacro)R_DATA_W=8 $(VSRC)
	@./a.out
ifeq ($(VCD),1)
	@if [ ! `pgrep gtkwave` ]; then gtkwave uut.vcd; fi &
endif

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
