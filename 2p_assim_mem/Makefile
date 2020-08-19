include ../mem.mk

#run the simulator
run:
	$(CMPLR) $(defmacro)R_BIG
	./a.out
	$(CMPLR)
	./a.out

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
