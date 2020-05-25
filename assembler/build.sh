#!/bin/bash
set -e

g++ main.cpp instr_set.cpp cpu.cpp assembler.cpp

echo "Success"