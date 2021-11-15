# Memory directory path
MEM_DIR:=.

include $(MEM_DIR)/config.mk

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
