ROOT_DIR := ../..
include $(ROOT_DIR)/mem.mk

# include iob_2p_assim_async_mem sources
VSRC+=$(filter-out $(wildcard $(ROOT_DIR)/2p_assim_async_mem/*_tb.v), $(wildcard $(ROOT_DIR)/2p_assim_async_mem/*.v))

#run the simulator
run:
	@$(CMPLR)
	@./a.out

sim:
	$(CMPLR) $(VCD) $(defmacro)WR_RATIO=4
	./a.out
	$(CMPLR) $(VCD) $(defmacro)WR_RATIO=2
	./a.out
	$(CMPLR) $(VCD) $(defmacro)RW_RATIO=4
	./a.out
	$(CMPLR) $(VCD) $(defmacro)RW_RATIO=2
	./a.out
	$(CMPLR) $(VCD) $(defmacro)WR_RATIO=1
	./a.out
	$(GTKW) $(WSRC)

clean:
	@rm -f ./a.out *.vcd

.PHONY: clean
