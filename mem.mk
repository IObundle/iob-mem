# macros used in several testbenches
defmacro := -D
USE_RAM = $(defmacro)USE_RAM
R_BIG = $(defmacro)R_BIG
VCD = $(defmacro)VCD

# optional ram
ifeq ($(RAM),1)
	DEFINE += $(USE_RAM)
endif

# Read data > write data
# By default, read data < write data
ifeq ($(R),1)
	DEFINE += $(R_BIG)
endif


# simulator flags
VSRC = *.v
VLOG = iverilog -W all -g2005-sv $(DEFINE)
CMPLR = $(VLOG) $(VSRC)

# hex files generation for tb
GEN_HEX1 := echo "!IObundle 2020!" | od -A n -t x1 > tb1.hex
GEN_HEX2 := echo "10 9 8 7 5 4 32" | od -A n -t x1 > tb2.hex

# wave viewer
GTKW = gtkwave -a
WSRC = waves.gtkw *.vcd

all: run
