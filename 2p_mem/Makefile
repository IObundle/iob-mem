#simulator flags
defmacro := -D
VSRC += *.v
DEFINE += $(defmacro)VCD
VLOG = iverilog -W all -g2005-sv $(DEFINE)

#run the simulator
run:
	$(VLOG) $(VSRC)
	./a.out

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
