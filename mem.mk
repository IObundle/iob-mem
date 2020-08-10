# optional VCD
ifeq ($(VCD),1)
	DEFINE += -DVCD
endif

# simulator flags
VSRC += *.v
VLOG := iverilog -W all -g2005-sv $(DEFINE)
CMPLR := $(VLOG) $(VSRC)
