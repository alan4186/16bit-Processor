#!/usr/bin/python

import sys
import csv

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

def hexFill(decStr):
    h = hexStr(decStr)
    while len(h) < 4:
        h = '0' + h
    return h

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
    data = op_code + field3 + field2 + field1
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
        offset = '0' + offset # will not account for negitive jumps
    data = op_code + offset
    return hex(int(data,16))

def datatype(row):
    data = int(row[data_start_col])
    # convert data to hex
    data = hexStr(data)
    if len(data) > 4:
        raise ValueError(data, "The Data value at address " +row[addressCol] + " must be 16 bits")
    while len(data) < 4:
        data = '0' + data
    return hex(int(data,16))

def emptyaddr(row):
    return hex(int("0000",16))

switch = { 'i':itype, 'r':rtype, 'j':jtype, 'd':datatype, 'x':emptyaddr}

print "Reading " + inFile + " as the source csv file"
with open(outFile, 'w') as of:
    print "Overiting "+ outFile + " if it exists"
    header = "WIDTH = 16;\nDEPTH=256;\n\nADDRESS_RADIX=UNS;\nDATA_RADIX=HEX;\n\nCONTENT BEGIN\n"
    of.write(header)

with open(inFile, 'r') as csvfile:
    csvreader = csv.reader(csvfile, delimiter=',',quotechar='|')
    headers = next(csvreader)
    for row in csvreader:
        # assume no headers
        with open(outFile,'a') as of:
            hexData = switch[row[typeCol]](row)
            line = row[addressCol+1] + "\t:\t" + hexFill(int(hexData,16)) + ";\n"
            of.write(line)

with open(outFile,'a') as of:
    of.write("END;")

print "\n\nDone!"

