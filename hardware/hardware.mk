MODULE:=MEM

#include memory modules
$(foreach p, $(MEM_MODULES), $(eval include $(MEM_HW_DIR)/$p/hardware.mk))
