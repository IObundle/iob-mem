ROOT_DIR := ../..
include $(ROOT_DIR)/mem.mk

#run the simulator
run:
	@$(CMPLR)
	@./a.out

sim:
	$(CMPLR) $(VCD)
	./a.out
	$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
