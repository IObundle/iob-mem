ROOT_DIR := ../..
include $(ROOT_DIR)/mem.mk

2P_ASSIM_MEM := $(ROOT_DIR)/2p_assim_mem
VSRC = $(2P_ASSIM_MEM)/*mem.v
VSRC += $(2P_ASSIM_MEM)/*big.v

#run the simulator
run:
	$(CMPLR) $(VSRC) $(R_BIG)
	./a.out
	$(CMPLR) $(VSRC)
	./a.out

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
