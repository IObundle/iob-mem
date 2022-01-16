MODULES+=fifo/sfifo_asym

# Paths
SFIFO_ASYM_DIR=$(MEM_HW_DIR)/fifo/sfifo_asym

# Submodules
ifneq (ram/2p_asym_ram,$(filter ram/2p_asym_ram, $(MODULES)))
include $(MEM_HW_DIR)/ram/2p_asym_ram/hardware.mk
endif

ifneq (fifo/bin_counter,$(filter fifo/bin_counter, $(MODULES)))
BIN_COUNTER_DIR=$(MEM_HW_DIR)/fifo
VSRC+=$(BIN_COUNTER_DIR)/bin_counter.v
endif

# Sources
VSRC+=$(SFIFO_ASYM_DIR)/iob_sync_fifo_asym.v

# Defines
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
