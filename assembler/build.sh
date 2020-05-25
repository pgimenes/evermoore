#!/bin/bash
set -e

g++ main.cpp instr_set.cpp cpu.cpp assembler.cpp -o assembler
./assembler program.txt

echo "Success"