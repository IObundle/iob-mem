# Makefile lists top level folders and tests if there's a Makefile in them.
# If there is, it runs 'make' in that directory; if not, it runs the compiler.
# To compile a specific memory module, type 'make <path-to-module>'

# find folders to work on
#DIRS := $(shell find . -type f -name '*.v' -printf '%h\n' | sort -u)
DIRS := $(wildcard */)

# simulator flags
defmacro := -D
VSRC += *.v
DEFINE += $(defmacro)VCD
VLOG = iverilog -W all -g2005-sv $(DEFINE)
CMPLR = $(VLOG) $(VSRC) && ./a.out

# run the simulator
all:
	for d in $(DIRS); do ( \
		if test -f $$d/Makefile; then make -C $$d; \
			else cd $$d && $(CMPLR); fi; ); \
		done

$(MAKECMDGOALS):
	if test -f $@/Makefile; then make -C $@; \
		else cd $@ && $(CMPLR); fi; \

clean:
	@find . -name "*.vcd" -type f -delete
	@find . -name "a.out" -type f -delete

.PHONY: all $(MAKECMDGOALS) clean
