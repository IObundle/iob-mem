DIRS := $(wildcard */)

all: $(DIRS)

$(DIRS):
	$(MAKE) -C $@

.PHONY: all $(DIRS) clean
