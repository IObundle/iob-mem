define_D:=-D

#simulator flags
VSRC += iob_2p_mem.v
VSRC += iob_2p_mem_tb.v
DEFINE += $(define_D) VCD
VLOG = iverilog -W all -g2005-sv $(DEFINE)

#run the simulator
all: a.out
	./$<	

a.out: $(VSRC)
	$(VLOG) $(VSRC)


clean: 
	@rm -f a.out *~ *.vcd

.PHONY: clean