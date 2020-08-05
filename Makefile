# find folders and subfolders to work on
DIRS += $(shell find -type f -name '*.v' -printf '%h\n' | sort -u)

# simulator flags
defmacro := -D
VSRC += *.v
DEFINE += $(defmacro)VCD
VLOG = iverilog -W all -g2005-sv $(DEFINE)
CMPLR = $(VLOG) $(VSRC) && ./a.out

# run the simulator
run:
	@echo $(DIRS)
	$(foreach dir, $(DIRS), $(shell cd $(dir) && $(CMPLR)))

clean:
	@find . -name "*.vcd" -type f -delete
	@find . -name "a.out" -type f -delete

.PHONY: clean
