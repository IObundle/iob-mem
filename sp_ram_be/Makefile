include ../mem.mk

# generate .hex file from string, checks from ram if string is valid
run:
	$(GEN_HEX1) && $(GEN_HEX2)
	$(CMPLR)
	./a.out

clean:
	@rm -f ./a.out *.vcd *.hex

.PHONY: clean
