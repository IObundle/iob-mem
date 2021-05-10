ROOT_DIR = ../..
include $(ROOT_DIR)/mem.mk

2P_MEM = $(ROOT_DIR)/dp_ram/dp_ram.v
VSRC += $(2P_MEM)

WSRC = waves.gtkw sfifo.vcd
ifeq ($(RAM),1)
	WSRC = waves_ram.gtkw sfifo_ram.vcd
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
