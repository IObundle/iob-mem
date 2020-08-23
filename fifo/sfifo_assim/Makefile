ROOT_DIR = ../..
include $(ROOT_DIR)/mem.mk

2P_ASSIM_MEM = $(ROOT_DIR)/2p_assim_mem
VSRC += $(2P_ASSIM_MEM)/*mem.v
VSRC += $(2P_ASSIM_MEM)/*big.v

WSRC = waves_w.gtkw sfifo_assim_w.vcd
ifeq ($(R),1)
	WSRC = waves_r.gtkw sfifo_assim_r.vcd
endif

#run the simulator
run:
	@$(CMPLR) $(R_BIG)
	@./a.out
	@$(CMPLR)
	@./a.out

sim:
	$(CMPLR) $(VCD)
	./a.out
	$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
