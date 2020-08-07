include mem.mk

all: $(MEM_DIR)

$(MEM_DIR):
	make -C $(MEM_DIR)

clean:
	@find . -name "*.vcd" -type f -delete
	@find . -name "a.out" -type f -delete

.PHONY: all $(MEM_DIR) clean
