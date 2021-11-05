ROOT_DIR = ../..
include $(ROOT_DIR)/mem.mk

DP_RAM = $(ROOT_DIR)/ram/dp_ram
FIFO = $(ROOT_DIR)/fifo/

VSRC += $(DP_RAM)/iob_dp_ram.v $(FIFO)/bin_counter.v

WSRC = waves_w.gtkw iob_sync_fifo_asym_with_sym_mem_w.vcd
ifeq ($(R),1)
	WSRC = waves_r.gtkw iob_sync_fifo_asym_with_sym_mem_r.vcd
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
