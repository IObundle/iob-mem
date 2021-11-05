ROOT_DIR = ../..
include $(ROOT_DIR)/mem.mk

2P_ASYM_MEM = $(ROOT_DIR)/ram/2p_asym_mem
VSRC += $(2P_ASYM_MEM)/*mem.v
VSRC += $(2P_ASYM_MEM)/*big.v

WSRC = waves_w.gtkw iob_sync_fifo_asym_w.vcd
ifeq ($(R),1)
	WSRC = waves_r.gtkw iob_sync_fifo_asym_r.vcd
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
