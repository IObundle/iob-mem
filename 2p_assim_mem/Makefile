include ../mem.mk

#run the simulator
run:
	$(CMPLR) $(R_BIG)
	./a.out
	$(CMPLR)
	./a.out

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
