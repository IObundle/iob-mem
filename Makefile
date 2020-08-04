defmacro := -D

#simulator flags
VSRC += *.v
DEFINE += $(defmacro)VCD
VLOG = iverilog -W all -g2005-sv $(DEFINE)
CMPLR = $(VLOG) $(VSRC) && ./a.out
DIRS = $(wildcard */)

#run the simulator
run:
	@echo $(DIRS)
	$(foreach d, $(DIRS), $(shell cd $d && $(CMPLR)) )

clean:
	@find . -name "*.vcd" -type f -delete
	@find . -name "a.out" -type f -delete

.PHONY: clean
