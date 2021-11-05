ROOT_DIR = ../..
include $(ROOT_DIR)/mem.mk

2P_MEM = $(ROOT_DIR)/ram/2p_ram/iob_2p_ram.v
VSRC += $(2P_MEM)

WSRC = waves.gtkw iob_sync_fifo.vcd
ifeq ($(RAM),1)
	WSRC = waves_ram.gtkw iob_sync_fifo_ram.vcd
endif

#run the simulator
run:
	@$(CMPLR) $(USE_RAM)
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
