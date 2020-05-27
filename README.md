# curly-lamp

To use the assembler, run the build.sh script. This runs with an example test program program.txt and upon execution a new file, program_assembled.mif will show up in the directory.

To run the program include the programs you want to assemble as command-line parameters:
./assembler <program_file_1.txt> <program_file_2.txt> <...> <program_file_n.txt>

The output will be in mif format which can be directly used with Quartus.

The following files cannot be changed or deleted for the program to run correctly, and they must always be in the same directory as the executable:
- instructions.txt
- instruction_opcodes.txt