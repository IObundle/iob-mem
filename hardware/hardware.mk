include $(MEM_DIR)/config.mk

define GET_MEM_MODULE_DIR
$(shell find $(MEM_HW_DIR) -name $(1))
endef

#include memory modules
$(foreach p, $(MEM_MODULES), $(if $(filter $p, $(MODULES)), , $(eval MEM_MODULES_DIRS+=$(call GET_MEM_MODULE_DIR, $p))))
$(foreach p, $(MEM_MODULES_DIRS), $(eval include $p/hardware.mk))

