include $(MEM_DIR)/config.mk

#include memory modules
$(foreach p, $(MEM_MODULES), $(eval MEM_MODULES_DIRS+=$(shell find $(MEM_HW_DIR) -name $p)))
$(foreach p, $(MEM_MODULES_DIRS), $(eval include $p/hardware.mk))

