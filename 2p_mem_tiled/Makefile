include ../mem.mk

2P_MEM = ../2p_mem
VSRC += $(2P_MEM)/iob_2p_mem.v

WSRC = waves_w.gtkw tiled_w.vcd

ifeq ($(R),1)
	WSRC = waves_r.gtkw tiled_r.vcd
endif

run:
	@$(CMPLR)
	@./a.out
	@$(CMPLR) $(R_BIG)
	@./a.out

#run the simulator
oldrun:
	@$(CMPLR)
	@./a.out
	@$(CMPLR) $(R_BIG)
	@./a.out

sim:
	@$(CMPLR) $(VCD)
	@./a.out
	@$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
