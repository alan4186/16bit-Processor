#!/usr/bin/python

import sys
import csv
from cStringIO import StringIO
from intelhex import IntelHex16bit

print sys.argv
if len(sys.argv) != 3:
  raise TypeError(sys.argv,"there must be 2 arguments: the source csv file and the output file")

inFile = sys.argv[1]
outFile = sys.argv[2]

addressCol = 0
data_start_col = 5
typeCol = 4

def hexStr(decStr):
    h = hex(int(decStr))
    h = h.split('x')[-1]
    return h

def computeChksum(line):
    sum = int(line[0:2],16)
    sum = sum + int(line[2:4],16)
    sum = sum + int(line[4:6],16)
    sum = twosCompliment(sum)
    sum = bin(sum)
    sum = sum.split('b')[-1]
    sum = hex(int(sum,2))
    sum = sum.split('x')[-1]
    while len(sum) < 2:
        sum = '0' + sum
    if len(sum) > 2:
        sum = sum[-2:]
    return sum
    
def twosCompliment(val):
    val = bin(val)
    ival = ''
    for bit in val:
        if bit == '0':
            ival = ival + '1'
        elif bit == '1':
            ival = ival + '0'
        elif bit == 'x':
            ival = ''
    ival = int(ival,2)
    return ival + 0b1

    
def itype(row):
    op_code = row[data_start_col]
    field3 = row[data_start_col + 1]
    field2 = row[data_start_col + 2]
    field1 = row[data_start_col + 3]
    # convert to hex
    op_code = hexStr(op_code)
    field3 = hexStr(field3)
    field2 = hexStr(field2)
    field1 = hexStr(field1)
    if len(op_code) != 1:
        raise ValueError(op_code,"The op_code at address " + row[addressCol] + "is not 4 bits")
    if len(field3) != 1:
        raise ValueError(field3, "field 3 at address " +row[addressCol] +" must be 4 bits")
    if len(field2) != 1:
        raise ValueError(field2, "field 2 at address " +row[addressCol] +" must be 4 bits")
    if len(field1) != 1:
        raise ValueError(field1, "field 1 at address " +row[addressCol] +" must be 4 bits")
    data = (op_code + field3)[::-1] + (field2 + field1)[::-1]
    data = data[::-1]
    return hex(int(data,16))

def rtype(row):
    return itype(row)

def jtype(row):
    op_code = row[data_start_col]
    offset = int(row[data_start_col + 1])
    if row[data_start_col+2] != 'x' or row[data_start_col+3] != 'x':
        print "WARNING: fields 2 and 1 may have non-placeholder values at address " + row[addressCol]
    # convert to hex
    op_code = hexStr(op_code)
    offset = hexStr(offset)
    if len(op_code) != 1:
        raise ValueError(op_code,"The op_code at address " + row[addresCol] + "is not 4 bits")
    if len(offset) > 3:
        raise ValueError(offset,"The Jump value at " + row[addressCol] +" is to large, it should be 12 bits or less")
    # build hex line for memory file
    while(len(offset) < 3):
        offset = '0' + offset
    data = op_code + offset
    data = (data[0:2])[::-1] + (data[2:4])[::-1]
    data = data[::-1]
    return hex(int(data,16))

def datatype(row):
    data = int(row[data_start_col])
    # convert data to hex
    data = hexStr(data)
    if len(data) > 4:
        raise ValueError(data, "The Data value at address " +row[addressCol] + " must be 16 bits")
    while len(data) < 4:
        data = '0' + data
    data = (data[0:2])[::-1] + (data[2:4])[::-1]
    data = data[::-1]
    return hex(int(data,16))

def emptyaddr(row):
    return hex(int("0000",16))

switch = { 'i':itype, 'r':rtype, 'j':jtype, 'd':datatype, 'x':emptyaddr}

print "Reading " + inFile + " as the source csv file"
with open(outFile, 'w') as dummy:
    print "Overiting "+ outFile + " if it exists"

with open(inFile, 'r') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',',quotechar='|')
    headers = next(csvreader)
    q = 0
    ih = IntelHex16bit()
    for row in csvreader:
        # assume no headers
        hexData = switch[row[typeCol]](row)
        print q
        ih[q] = int( hexData,16)
        q = q + 1
sio = StringIO()
ih.write_hex_file(sio)
hexString = sio.getvalue()
sio.close()

with open(outFile,'w') as of:
    of.write(hexString)

print "\n\nDone!"

