#!/usr/bin/python

#tdp_ram usage: memakerwrap tech type Nmems {words bits bytes mux}{Nmems}
#dp_ram usage: memakerwrap tech type Nmems {words bits bytes mux}{Nmems}
#t2p_ram usage: memakerwrap tech type Nmems {words bits bytes mux}{Nmems}
#2p_ram usage: memakerwrap tech type Nmems {words bits bytes mux}{Nmems}
#sp_ram usage: memakerwrap tech type words bits bytes mux

#rom usage: memakerwrap tech type words bits mux romcode

import sys

#
# extract command line arguments
#

mems = []

if sys.argv[1] == "fsc0l_d":
    tech = "LD130"
    if sys.argv[2] == "sz":
        type = "SZ"
        async = int(sys.argv[3])
        for i in range(int(sys.argv[4])):
            words = int(sys.argv[5 + i*4])
            bits  = int(sys.argv[6 + i*4])
            bytes = int(sys.argv[7 + i*4])
            mux   = int(sys.argv[8 + i*4])
            mems.append([words, bits, bytes, mux])
    elif sys.argv[2] == "sj":
        type = "SJ"
        async = int(sys.argv[3])
        for i in range(int(sys.argv[4])):
            words = int(sys.argv[5 + i*4])
            bits  = int(sys.argv[6 + i*4])
            bytes = int(sys.argv[7 + i*4])
            mux   = int(sys.argv[8 + i*4])
            mems.append([words, bits, bytes, mux])
    elif sys.argv[2] == "sh":
        type = "SH"
        words = int(sys.argv[3])
        bits  = int(sys.argv[4])
        bytes = int(sys.argv[5])
        mux   = int(sys.argv[6])
        mems.append([words, bits, bytes, mux])
    elif sys.argv[2] == "sp":
        type = "SP"
        words = int(sys.argv[3])
        bits  = int(sys.argv[4])
        mux   = int(sys.argv[5])
        mems.append([words, bits, mux])
    else:
        sys.exit("Unsupported memory type")
else:
    sys.exit("Unsupported memory technology")

#
# print time scale
#

print "`timescale 1ns / 1ps"
print ""

#
# print mem interface
#

if type == "SZ":
    if async: print "module t2p_ram"
    else: print "module 2p_ram"
    print "  #("
    print "    parameter DATA_W = 8,"
    print "    parameter ADDR_W = 9,"
    print "    parameter USE_RAM = 1"
elif type == "SJ":
    if async: print "module tdp_ram"
    else: print "module dp_ram"
    print "  #("
    print "    parameter FILE = \"none\","
    print "    parameter DATA_W = 8,"
    print "    parameter ADDR_W = 9"
elif type == "SH":
    print "module sp_ram"
    print "  #("
    print "    parameter FILE = \"none\","
    print "    parameter DATA_W = 8,"
    print "    parameter ADDR_W = 14"
elif type == "SP":
    print "module sp_rom"
    print "  #("
    print "    parameter DATA_W = 8,"
    print "    parameter ADDR_W = 9,"
    print "    parameter FILE = \"rom.dat\""
print "    )"
print "  ("
if type == "SZ":
    if async:
        print "            input wclk,"
        print "            input rclk,"
    else:
        print "            input clk,"
    print ""
    #
    # write port
    #
    print "            input w_en,"
    print "            input [ADDR_W-1:0] w_addr,"
    print "            input [DATA_W-1:0] data_in,"
    print ""
    #
    # read port
    #
    print "            input r_en,"
    print "            input [ADDR_W-1:0] r_addr,"
    print "            output [DATA_W-1:0] data_out"
elif type == "SJ":
    if async:
        print "            input clk_a,"
        print "            input clk_b,"
    else:
        print "            input clk,"
    print ""
    #
    # port A
    #
    print "            input en_a,"
    print "            input [ADDR_W-1:0] addr_a,"
    print "            input [DATA_W-1:0] data_a,"
    print "            input we_a,"
    print "            input [DATA_W-1:0] q_a,"
    print ""
    #
    # port B
    #
    print "            input en_b,"
    print "            input [ADDR_W-1:0] addr_b,"
    print "            input [DATA_W-1:0] data_b,"
    print "            input we_b,"
    print "            input [DATA_W-1:0] q_b"
elif type == "SH":
    print "            input clk,"
    print ""
    print "            input en,"
    print "            input [ADDR_W-1:0] addr,"
    print "            input [DATA_W-1:0] data_in,"
    print "            input we,"
    print "            output [DATA_W-1:0] data_out"
elif type == "SP":
    print "            input clk,"
    print ""
    print "            input [ADDR_W-1:0] addr,"
    print "            output [DATA_W-1:0] rdata,"
    print "            input r_en"
print "           );"
print ""

#
# mux signals for ram
#

if type == "SZ":
    if async:
        print "   wire clkA = wclk;"
        print "   wire clkB = rclk;"
    else:
        print "   wire clkA = clk;"
        print "   wire clkB = clk;"
    print "   wire wen = ~w_en;"
    print "   wire csnA = ~w_en;"
    print "   wire csnB = ~r_en;"
elif type == "SJ":
    if async:
        print "   wire clkA = clk_a;"
        print "   wire clkB = clk_b;"
    else:
        print "   wire clkA = clk;"
        print "   wire clkB = clk;"
    print "   wire wenA = ~we_a;"
    print "   wire wenB = ~we_b;"
    print "   wire oeA = 1'b1; //en_a;"
    print "   wire oeB = 1'b1; //en_b;"
elif type == "SH":
    print "   wire ["+str(bytes-1)+":0] wen = ~we;"
    print "   wire oe = 1'b1; //en & ~(|we);"
elif type == "SP":
    print "   wire oe = 1'b1; //r_en;"
print ""

#
# instantiate generated mem
#

if len(mems) > 1: print "generate"

for j in range(len(mems)):
    if type == "SP": [words, bits, mux] = mems[j]
    else: [words, bits, bytes, mux] = mems[j]
    
    if len(mems) > 1: print "if (ADDR_W == " + str(words) + ") begin"
    
    if tech == "LD130":
        if type == "SZ":
            print "   "+type+tech+"_"+str(2**words)+"X"+str(bits)+"X"+str(bytes)+"CM"+str(mux)+" ram"+str(j)
        elif type == "SJ":
            print "   "+type+tech+"_"+str(2**words)+"X"+str(bits)+"X"+str(bytes)+"CM"+str(mux)+" ram"+str(j)
        elif type == "SH":
            print "   "+type+tech+"_"+str(2**words)+"X"+str(bits)+"X"+str(bytes)+"BM"+str(mux)+" ram"+str(j)
        elif type == "SP":
            print "   "+type+tech+"_"+str(2**words)+"X"+str(bits)+"BM"+str(mux)+"A rom"+str(j)
    
    print "   ("
    
    if type == "SZ":
        for i in range(bits*bytes):
            print "    .DO"+str(i)+"(data_out["+str(i)+"]),"
        print ""
        for i in range(bits*bytes):
            print "    .DI"+str(i)+"(data_in["+str(i)+"]),"
        print ""
        if bytes > 1:
            for i in range(bytes):
                print "    .WEB"+str(i)+"(wen),"
        else:
            print "    .WEB(wen),"
        print ""
        print "    .CSAN(csnA),"
        print "    .CSBN(csnB),"
    elif type == "SJ":
        for i in range(bits*bytes):
            print "    .DOA"+str(i)+"(q_a["+str(i)+"]),"
        print ""
        for i in range(bits*bytes):
            print "    .DOB"+str(i)+"(q_b["+str(i)+"]),"
        print ""
        for i in range(bits*bytes):
            print "    .DIA"+str(i)+"(data_a["+str(i)+"]),"
        print ""
        for i in range(bits*bytes):
            print "    .DIB"+str(i)+"(data_b["+str(i)+"]),"
        print ""
        if bytes > 1:
            for i in range(bytes):
                print "    .WEAN"+str(i)+"(wenA),"
            print ""
            for i in range(bytes):
                print "    .WEBN"+str(i)+"(wenB),"
        else:
            print "    .WEAN(wenA),"
            print "    .WEBN(wenB),"
        print ""
        print "    .CSA(en_a),"
        print "    .CSB(en_b),"
        print ""
        print "    .OEA(oeA),"
        print "    .OEB(oeB),"
    elif type == "SH":
        for i in range(bits*bytes):
            print "    .DO"+str(i)+"(data_out["+str(i)+"]),"
        print ""
        for i in range(bits*bytes):
            print "    .DI"+str(i)+"(data_in["+str(i)+"]),"
        print ""
        if bytes > 1:
            for i in range(bytes):
                print "    .WEB"+str(i)+"(wen["+str(i)+"]),"
        else:
            print "    .WEB(wen),"
        print ""
        print "    .CS(en),"
        print "    .OE(oe),"
    elif type == "SP":
        for i in range(bits):
            print "    .DO"+str(i)+"(rdata["+str(i)+"]),"
        print "    .CS(r_en),"
        print "    .OE(oe),"
    print ""
    
    if type == "SZ":
        for i in range(words):
            print "    .A"+str(i)+"(w_addr["+str(i)+"]),"
        print ""
        for i in range(words):
            print "    .B"+str(i)+"(r_addr["+str(i)+"]),"
        print ""
        print "    .CKA(clkA),"
        print "    .CKB(clkB)"
    elif type == "SJ":
        for i in range(words):
            print "    .A"+str(i)+"(addr_a["+str(i)+"]),"
        print ""
        for i in range(words):
            print "    .B"+str(i)+"(addr_b["+str(i)+"]),"
        print ""
        print "    .CKA(clkA),"
        print "    .CKB(clkB)"
    else:
        for i in range(words):
            print "    .A"+str(i)+"(addr["+str(i)+"]),"
        print ""
        print "    .CK(clk)"
    
    print "   );"
    print ""
    
    if len(mems) > 1: print "end"
    if (len(mems) - j) > 1: print "else"
    elif len(mems) > 1: print "endgenerate\n"

print "endmodule"
