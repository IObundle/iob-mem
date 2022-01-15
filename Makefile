MEM_DIR:=.

include $(MEM_DIR)/config.mk

defmacro:=-D
incdir:=-I

ifeq ($(VCD),1)
DEFINE+=$(defmacro)VCD
endif

include $(MODULE_DIR)/hardware.mk

# testbench
VSRC+=$(wildcard $(MODULE_DIR)/*_tb.v)


# Icarus Verilog simulator flags

VLOG=iverilog -W all -g2005-sv $(INCLUDE) $(DEFINE)

corename:
	@echo "MEM"

#
# Simulate
#

sim: $(VSRC) $(VHDR) build gen-hex
	$(VLOG) $(VSRC)
	./a.out
ifeq ($(VCD),1)
	if [ ! `pgrep gtkwave` ]; then gtkwave uut.vcd; fi &
endif

# hex files generation for tb
# generate .hex file from string, checks from ram if string is valid
HEX_FILES:= tb1.hex tb2.hex
GEN_HEX1:=echo "!IObundle 2020!" | od -A n -t x1 > tb1.hex
GEN_HEX2:=echo "10 9 8 7 5 4 32" | od -A n -t x1 > tb2.hex
gen-hex: $(HEX_FILES)

$(HEX_FILES):
	@$(GEN_HEX1)
	@$(GEN_HEX2)

#
# Clean
# 

clean:
	@rm -f *~ \#*\# a.out *.vcd *.hex *.drom *.png *.pyc

.PHONY: all \
	corename \
	sim sim-clean \
	build gen-hex \
	clean
