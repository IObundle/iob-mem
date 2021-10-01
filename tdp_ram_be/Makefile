include ../mem.mk

TDP_MEM = ../tdp_ram
VSRC += $(TDP_MEM)/iob_tdp_ram.v

# generate .hex file from string, checks from ram if string is valid
run:
	@$(GEN_HEX1) && $(GEN_HEX2)
	@$(CMPLR)
	@./a.out

sim:
	$(GEN_HEX1) && $(GEN_HEX2)
	$(CMPLR) $(VCD)
	./a.out
	$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd *.hex

.PHONY: clean
