defmacro:=-D
incdir:=-I

#simulator flags
VSRC += iob_2p_assim_mem_r_big.v
DEFINE += $(defmacro)VCD
VLOG = iverilog -W all -g2005-sv $(DEFINE)

#run the simulator
run:
	$(VLOG) $(VSRC)
	./a.out

clean:
	@rm -f ./a.out

.PHONY: clean
