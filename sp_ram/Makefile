include ../mem.mk

# generate .hex file from string, checks from rom if string is valid
run:
	@echo "!IObundle 2020!" | od -A n -t x1 > tb1.hex
	@echo "10 9 8 7 5 4 32" | od -A n -t x1 > tb2.hex
	$(CMPLR)
	./a.out

clean:
	@rm -f ./a.out *.vcd *.hex

.PHONY: clean
