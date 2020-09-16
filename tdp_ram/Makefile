include ../mem.mk

VCD2DROM = vcd2wavedrom.py --config tdp_ram.json --input tdp_ram.vcd --output tdp_ram.drom
PNG = npx wavedrom-cli -i tdp_ram.drom -p tdp_ram_print.png

# generate .hex file from string, checks from ram if string is valid
run:
	@$(GEN_HEX1) && $(GEN_HEX2)
	@$(CMPLR)
	@./a.out

sim:
	$(GEN_HEX1) && $(GEN_HEX2)
	$(CMPLR) $(VCD)
	$(VCD2DROM) $(PNG)
	./a.out
	$(GTKW) $(WSRC)



clean:
	@rm -f ./a.out *.vcd *.hex

.PHONY: clean
