#
# PRIMARY PARAMETERS
#

# Default module path to simulate
MODULE_DIR ?=ram/sp_ram

# Default simulator (simulators: icarus)
SIM ?=icarus

# generate .vcd file by default
VCD ?=1

# optional ram
USE_RAM ?=1

# Read data > write data
# By default, read data < write data
R_BIG ?=0

####################################################################
# DERIVED FROM PRIMARY PARAMETERS: DO NOT CHANGE BELOW THIS POINT
####################################################################

include $(MEM_DIR)/mem.mk

#
# Defines
#

ifeq ($(SIM),xcelium)
defmacro:=-define 
incdir:=-incdir 
else
defmacro:=-D
incdir:=-I
endif

ifeq ($(USE_RAM),1)
DEFINE+=$(defmacro)USE_RAM
endif

ifeq ($(R_BIG),1)
DEFINE+=$(defmacro)R_BIG
endif

ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif

#
# Sources
#

include $(MODULE_DIR)/hardware.mk

# testbench
VSRC+=$(wildcard $(MODULE_DIR)/*_tb.v)

# hex files generation for tb
# generate .hex file from string, checks from ram if string is valid
HEX_FILES:= tb1.hex tb2.hex
GEN_HEX1:=echo "!IObundle 2020!" | od -A n -t x1 > tb1.hex
GEN_HEX2:=echo "10 9 8 7 5 4 32" | od -A n -t x1 > tb2.hex

#
# Simulator flags
#

VLOG=iverilog -W all -g2005-sv $(INCLUDE) $(DEFINE)

#
# Script to generate .drom file
#

GEN_WAVEDROM=$(MEM_PYTHON_DIR)/vcd2wavedrom.py --config $(MODULE_DIR)/*.json --input *.vcd --output $(MODULE_DIR)/*.drom

#
# Wavedrom
#

WAVEDROM=npx wavedrom-cli -i $(MODULE_DIR)/*.drom -p $(MODULE_DIR)/*.png

#
# Wave viewer
#

GTKW=gtkwave -a
WSRC=waves.gtkw *.vcd

#
# Targets
#

all: run

run: build gen-hex
	./a.out
ifeq ($(VCD),1)
	$(GTKW) $(WSRC)
endif
ifeq ($(VCD2DROM),1)
	$(GEN_WAVEDROM)
endif
ifeq ($(PNG),1)
	$(WAVEDROM)
endif

build: a.out

a.out: $(VSRC) $(VHDR)
	$(VLOG) $(VSRC)

gen-hex: $(HEX_FILES)

$(HEX_FILES):
	@$(GEN_HEX1)
	@$(GEN_HEX2)

clean:
	@rm -f *~ \#*\# a.out *.vcd *.hex *.drom *.png *.pyc

.PHONY: all run build gen-hex clean
