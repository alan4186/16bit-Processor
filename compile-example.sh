#!/bin/bash
# this is an example command to execute the python pusdo compile script
# the script takes a csv file like "Scalar_x_Matrix.csv" and formats it into
# an intel .hex memory file like "Scalar_x_Matrix.hex"
python psudo-compiler.py Instruction_Plan/Scalar_x_Matrix.csv Scalar_x_Matrix.hex
