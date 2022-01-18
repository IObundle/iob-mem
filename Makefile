MEM_DIR:=.
include $(MEM_DIR)/config.mk

# Defaults
ADDR_W ?=4
DATA_W ?=32

defmacro:=-D
incdir:=-I

include $(MODULE_DIR)/hardware.mk

# Defines
ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif

DEFINE+=$(defmacro)ADDR_W=$(ADDR_W)
DEFINE+=$(defmacro)DATA_W=$(DATA_W)

# Testbench
VSRC+=$(wildcard $(MODULE_DIR)/*_tb.v)


# Icarus Verilog simulator flags

VLOG=iverilog -W all -g2005-sv $(INCLUDE) $(DEFINE)

#
# Targets
#

corename:
	@echo "MEM"

#
# Simulate
#

sim: $(VSRC) $(VHDR) gen-hex
	$(VLOG) $(VSRC)
	./a.out
ifeq ($(VCD),1)
	if [ ! `pgrep gtkwave` ]; then gtkwave uut.vcd; fi &
endif

# hex files generation for tb
# generate .hex file from string, checks from ram if string is valid
HEX_FILES:=data.hex
GEN_HEX:=echo "!IObundle 2020!" | od -A n -t x1 > data.hex
gen-hex: $(HEX_FILES)

$(HEX_FILES):
	@$(GEN_HEX)

#
# Clean
# 

clean:
	@rm -f *~ \#*\# a.out *.vcd *.hex *.drom *.png *.pyc

.PHONY: corename \
	sim \
	gen-hex \
	clean
