include $(MEM_DIR)/config.mk

#include memory modules
$(foreach p, $(MEM_MODULES), $(if $(filter $p, $(MODULES)), ,$(eval include $(MEM_HW_DIR)/$p/hardware.mk)))
