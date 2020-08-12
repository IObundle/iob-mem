include ../mem.mk

# generate .hex file from string, checks from rom if string is valid
run:
	@echo "!IObundle 2020!" | od -A n -t x1 > tb.hex
	$(CMPLR)
	./a.out

clean:
	@rm -f ./a.out *.vcd tb.hex

.PHONY: clean
