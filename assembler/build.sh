#!/bin/bash
set -e

g++ main.cpp instr_set.cpp cpu.cpp

echo "Success"