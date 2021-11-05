ROOT_DIR:=../..
include $(ROOT_DIR)/mem.mk

WSRC = waves_w.gtkw iob_2p_asym_mem_w.vcd

ifeq ($(R),1)
	WSRC = waves_r.gtkw iob_2p_asym_mem_r.vcd
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
