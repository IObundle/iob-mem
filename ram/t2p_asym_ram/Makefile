ROOT_DIR:=../..
include $(ROOT_DIR)/mem.mk

WSRC = waves_w.gtkw iob_t2p_asym_async_mem_w.vcd

ifeq ($(R),1)
	WSRC = waves_r.gtkw iob_t2p_asym_async_mem_r.vcd
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
