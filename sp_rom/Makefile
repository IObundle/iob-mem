 include ../mem.mk

# generate .hex file from string, checks from rom if string is valid
run:
	@$(GEN_HEX1)
	@$(CMPLR)
	@./a.out

sim:
	$(GEN_HEX1)
	$(CMPLR) $(VCD)
	./a.out
	$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd *.hex

.PHONY: clean
