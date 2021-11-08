MEM_DIR:=.
include mem.mk

#
# Simulate
#

sim:
	make run

sim-clean:
	make clean

#
# Clean
# 

clean: sim-clean

.PHONY: sim sim-clean \
	clean
