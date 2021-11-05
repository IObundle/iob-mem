ROOT_DIR:=../..
include $(ROOT_DIR)/mem.mk

DP_RAM=../dp_ram
VSRC+=$(DP_RAM)/iob_dp_ram.v

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
