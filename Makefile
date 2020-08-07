# Makefile lists top level folders and tests if there's a Makefile in them.
# If there is, it runs 'make' in that directory; if not, it runs the compiler.

# find folders to work on
DIRS := $(wildcard */)

# optional VCD
ifeq ($(VCD),1)
	defmacro := -D
	DEFINE += $(defmacro)VCD
endif

# simulator flags
VSRC += *.v
VLOG = iverilog -W all -g2005-sv $(DEFINE)
export CMPLR = $(VLOG) $(VSRC)

# run the simulator
all:
	@for d in $(DIRS); do ( \
		if test -f $$d/Makefile; then make -C $$d; \
			else cd $$d && $(CMPLR) && ./a.out; fi; ); \
	done

$(MAKECMDGOALS):
	@if test -f $@/Makefile; then make -C $@; \
		else cd $@ && $(CMPLR) && ./a.out; fi; \
clean:
	@find . -name "*.vcd" -type f -delete
	@find . -name "a.out" -type f -delete

.PHONY: all $(MAKECMDGOALS) clean
