ROOT_DIR:=../..
include $(ROOT_DIR)/mem.mk

2P_ASYM_MEM=../2p_asym_mem
VSRC+=$(2P_ASYM_MEM)/iob_2p_asym_mem.v
VSRC+=$(2P_ASYM_MEM)/iob_2p_asym_mem_w_big.v
VSRC+=$(2P_ASYM_MEM)/iob_2p_asym_mem_r_big.v

WSRC = waves_w.gtkw iob_2p_asym_mem_tiled_w.vcd

ifeq ($(R),1)
	WSRC = waves_r.gtkw iob_2p_asym_mem_tiled_r.vcd
endif

#run the simulator
run:
	@$(CMPLR)
	@./a.out
	@$(CMPLR) $(USE_RAM)
	@./a.out
	@$(CMPLR) $(R_BIG)
	@./a.out

sim:
	$(CMPLR) $(VCD)
	./a.out
	$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
