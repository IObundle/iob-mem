ROOT_DIR:=../..
include $(ROOT_DIR)/mem.mk

WSRC = waves.gtkw iob_t2p_mem.vcd
ifeq ($(RAM),1)
	WSRC = waves_ram.gtkw iob_t2p_mem_ram.vcd
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
