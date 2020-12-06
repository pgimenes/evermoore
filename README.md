# Evermoore

This was an end-of-year group project conducted in the Summer of 2020, aimed at implementing a 16-bit ARM-based CPU architecture optimised for three benchmark algorithms.

The algorithms were:
1. Evaluation of Fibonacci sequence using a recursive function. This was enabled by a stack register included in the design to keep track of recursions.

2. Calculate pseudo-random integers with a linear congruential generator, making use of a custom multiplication block within the ALU.

3. Traversing a linked list stored in pointer format, making effective use of indirect addressing.

A reference of the instruction set is available in "InstructionSet.pdf", and the code for each algorithm is in the src directory.

**Assembler**

To use the assembler, run the build.sh script. This runs with two test programs program1.txt, and program2.txt and upon execution the output mif file for each will appear in the directory.

To run the program include the programs you want to assemble as command-line parameters:
./assembler <program_file_1.txt> <program_file_2.txt> <...> <program_file_n.txt>

The output will be in mif format which can be directly used with Quartus.

The following files cannot be changed or deleted for the program to run correctly, and they must always be in the same directory as the executable:
- instructions.txt
- instruction_opcodes.txt
- COND_codes.txt
