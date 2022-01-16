MODULES+=fifo/afifo_asym

# Paths
FIFO_DIR=$(MEM_HW_DIR)/fifo
AFIFO_ASYM_DIR=$(MEM_HW_DIR)/fifo/afifo_asym

# Submodules
ifneq (ram/t2p_asym_ram,$(filter ram/t2p_asym_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/t2p_asym_ram/hardware.mk
endif

# Sources
VSRC+=$(AFIFO_ASYM_DIR)/iob_async_fifo_asym.v
VSRC+=$(FIFO_DIR)/gray2bin.v $(FIFO_DIR)/gray_counter.v

# Defines
#W_WIDE_R_NARROW=1

ifeq ($(W_WIDE_R_NARROW),1)
DEFINE += "$(defmacro)WR_RATIO=4"
DEFINE += "$(defmacro)W_WIDE_R_NARROW=1"
DEFINE += $(defmacro)W_DATA_W=4
DEFINE += $(defmacro)W_ADDR_W=4
DEFINE += $(defmacro)R_DATA_W=1
DEFINE += $(defmacro)R_ADDR_W=6
else
DEFINE += "$(defmacro)RW_RATIO=4"
DEFINE += "$(defmacro)W_NARROW_R_WIDE=1"
DEFINE += $(defmacro)R_DATA_W=4
DEFINE += $(defmacro)R_ADDR_W=4
DEFINE += $(defmacro)W_DATA_W=1
DEFINE += $(defmacro)W_ADDR_W=6
endif
