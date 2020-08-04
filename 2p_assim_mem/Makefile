defmacro:=-D

#simulator flags
VSRC += iob_2p_assim_mem_w_big.v
VSRC += iob_2p_assim_mem_w_big_tb.v
DEFINE += $(defmacro)VCD
VLOG = iverilog -W all -g2005-sv $(DEFINE)

#run the simulator
run:
	$(VLOG) $(VSRC)
	./a.out

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
