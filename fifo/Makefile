DIRS := $(wildcard */)

run:
	@for d in $(DIRS); do ( \
		if test -f $$d/Makefile; then make -C $$d; \
			else cd $$d && $(CMPLR) && ./a.out; fi; ); \
	done

clean:
	@rm -f ./a.out

.PHONY: clean
