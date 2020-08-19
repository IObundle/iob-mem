ROOT_DIR := ../..
include $(ROOT_DIR)/mem.mk

2P_MEM := $(ROOT_DIR)/2p_mem/iob_2p_mem.v
VSRC = $(2P_MEM)

#run the simulator
run:
	$(CMPLR) $(VSRC) 
	./a.out
	$(CMPLR) $(VSRC) $(RAM)
	./a.out

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
