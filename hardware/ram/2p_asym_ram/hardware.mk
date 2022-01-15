include $(MEM_HW_DIR)/ram/2p_ram/hardware.mk

MODULES+=ram/2p_asym_ram

2P_ASYM_RAM_DIR=$(MEM_HW_DIR)/ram/2p_asym_ram

VSRC+=$(2P_ASYM_RAM_DIR)/iob_2p_asym_ram.v

#W_WIDE_R_NARROW=1

ifeq ($(W_WIDE_R_NARROW),1)
DEFINE += "$(defmacro)W_WIDE_R_NARROW=1"
DEFINE += $(defmacro)W_DATA_W=4
DEFINE += $(defmacro)W_ADDR_W=4
DEFINE += $(defmacro)R_DATA_W=1
DEFINE += $(defmacro)R_ADDR_W=6
else
DEFINE += "$(defmacro)W_NARROW_R_WIDE=1"
DEFINE += $(defmacro)R_DATA_W=4
DEFINE += $(defmacro)R_ADDR_W=4
DEFINE += $(defmacro)W_DATA_W=1
DEFINE += $(defmacro)W_ADDR_W=6
endif
