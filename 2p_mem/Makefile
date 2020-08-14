include ../mem.mk

#run the simulator
run:
	$(CMPLR)
	./a.out
	$(CMPLR) $(RAM)
	./a.out

clean:
	@rm -f *.out *.vcd

.PHONY: clean
