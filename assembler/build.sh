#!/bin/bash
set -e

g++ main.cpp instr_set.cpp cpu.cpp assembler.cpp -o assembler
./assembler program1.txt program2.txt program3.txt

echo "Success"