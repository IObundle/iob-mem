defmacro:=-D
incdir:=-I

MEM_DIR=.

# Default module
MEM_NAME ?= iob_ram_sp
MODULE_DIR = $(shell find . -name $(MEM_NAME))

# list of asymmetric memories
IS_ASYM = $(shell echo $(MEM_NAME) | grep fifo)
IS_ASYM += $(shell echo $(MEM_NAME) | grep 2p)
IS_ASYM += $(shell echo $(MEM_NAME) | grep dp)



# DEFINES
DEFINE+=$(defmacro)ADDR_W=10
DEFINE+=$(defmacro)DATA_W=32
ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif

# INCLUDES
INCLUDE+=$(incdir)./submodules/LIB/hardware/include

# SOURCES
ifneq ($(MODULE_DIR),)
include $(MODULE_DIR)/hardware.mk
endif
# testbench
VSRC+=$(wildcard $(MODULE_DIR)/$(MEM_NAME)_tb.v)

ALL_HW_MODULES=$(shell find . -name hardware.mk -not -path './submodules/*' | sed 's/\/hardware.mk//g' | tail -n +3)

# Rules
.PHONY: sim sim-asym sim-all clean $(ALL_HW_MODULES) exists debug

#
# Simulate
#

# Icarus Verilog simulator flags
VLOG=iverilog -W all -g2005-sv $(INCLUDE) $(DEFINE)

sim: exists $(VSRC) $(VHDR)
ifeq ($(IS_ASYM),)
	make sim-sym
else
	make sim-asym
endif
ifeq ($(VCD),1)
	@if [ ! `pgrep gtkwave` ]; then gtkwave uut.vcd; fi &
endif

sim-sym:
	$(VLOG) $(VSRC)
	@./a.out

sim-asym: exists $(VSRC) $(VHDR)
	@echo "\n\nTesting module $(MEM_NAME)\n\n"
	$(VLOG) $(defmacro)W_DATA_W=32 $(defmacro)R_DATA_W=8 $(VSRC)
	@./a.out
	$(VLOG) $(defmacro)W_DATA_W=8 $(defmacro)R_DATA_W=32 $(VSRC)
	@./a.out
	$(VLOG) $(defmacro)W_DATA_W=8 $(defmacro)R_DATA_W=8 $(VSRC)
	@./a.out

sim-all: $(ALL_HW_MODULES)
	@echo "Listing all modules: $(ALL_HW_MODULES)"

$(ALL_HW_MODULES):
	make sim MEM_NAME=$(shell basename $@)

exists:
ifeq ($(MODULE_DIR),)
	$(error "Module $(MEM_NAME) not found")
endif
	@echo "\n\nSimulating module $(MEM_NAME)\n\n"


#
# DEBUG
#

debug:
	@echo $(IS_ASYM)
	@echo $(MODULE_DIR)
	@echo $(VSRC)
	@echo $(HW_MODULES)

#
# Clean
#

clean:
	@rm -f *~ \#*\# a.out *.vcd *.drom *.png *.pyc
