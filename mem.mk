# find folders to work on
DIRS := $(wildcard */)
MEM_DIR := $(MAKECMDGOALS)

# optional VCD
ifeq ($(VCD),1)
	defmacro := -D
	DEFINE += $(defmacro)VCD
endif

# simulator flags
VSRC += *.v
VLOG = iverilog -W all -g2005-sv $(DEFINE)
CMPLR = $(VLOG) $(VSRC)
