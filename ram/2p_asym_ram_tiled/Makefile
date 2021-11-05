ROOT_DIR:=../..
include $(ROOT_DIR)/mem.mk

2P_ASYM_RAM=../2p_asym_ram
VSRC+=$(2P_ASYM_RAM)/iob_2p_asym_ram.v
VSRC+=$(2P_ASYM_RAM)/iob_2p_asym_ram_w_big.v
VSRC+=$(2P_ASYM_RAM)/iob_2p_asym_ram_r_big.v

WSRC = waves_w.gtkw iob_2p_asym_ram_tiled_w.vcd

ifeq ($(R),1)
	WSRC = waves_r.gtkw iob_2p_asym_ram_tiled_r.vcd
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
