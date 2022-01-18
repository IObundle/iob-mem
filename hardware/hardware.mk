#include memory modules
$(foreach p, $(MEM_MODULES), $(if $(filter $p, $(MODULES)), ,$(eval MEM_NAME:=$p) $(eval include $(MEM_HW_DIR)/$p/hardware.mk)))
