include ../mem.mk

2P_MEM = ../dp_ram
VSRC += $(2P_MEM)/dp_ram.v

WSRC = waves.gtkw tiled.vcd

ifeq ($(RAM),1)
	WSRC = waves_ram.gtkw tiled_ram.vcd
endif

run:
	@$(CMPLR)
	@./a.out
	@$(CMPLR) $(USE_RAM)
	@./a.out

sim:
	@$(CMPLR) $(VCD)
	@./a.out
	@$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
