DIRS = $(wildcard */)
ifneq ($(MAKECMDGOALS),clean)
	DIR = $(MAKECMDGOALS)
endif

all: $(DIRS)

$(DIRS):
	@$(MAKE) -C $@

$(DIR):
	$(MAKE) -C $(DIR)

clean:
	@find . -name "*.vcd" -type f -delete
	@find . -name "a.out" -type f -delete
	@find . -name "*.hex" -type f -delete

.PHONY: all $(DIRS) clean $(MAKECMDGOALS)
