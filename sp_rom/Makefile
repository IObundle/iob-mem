 include ../mem.mk

# generate .hex file from string, checks from rom if string is valid
run:
	$(GEN_HEX1)
	$(CMPLR)
	./a.out

clean:
	@rm -f ./a.out *.vcd tb.hex

.PHONY: clean
