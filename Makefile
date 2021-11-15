# Memory directory path
MEM_DIR:=.

include $(MEM_DIR)/config.mk

#
# Defines
#

defmacro:=-D
incdir:=-I

ifeq ($(USE_RAM),1)
DEFINE+=$(defmacro)USE_RAM
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
# Wave viewer
#

GTKW=gtkwave -a
WSRC=waves.gtkw *.vcd

all: sim

#
# Simulate
#

sim: build gen-hex
	./a.out
ifeq ($(VCD),1)
	$(GTKW) $(WSRC)
endif

build: a.out

a.out: $(VSRC) $(VHDR)
	$(VLOG) $(VSRC)

gen-hex: $(HEX_FILES)

$(HEX_FILES):
	@$(GEN_HEX1)
	@$(GEN_HEX2)

sim-clean:
	@rm -f *~ \#*\# a.out *.vcd *.hex *.drom *.png *.pyc

#
# Clean
# 

clean: sim-clean

.PHONY: all \
	sim sim-clean \
	build gen-hex \
	clean
