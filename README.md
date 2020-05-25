# curly-lamp

To use the assembler, run the build.sh script then run the program with the following command-line parameters:
./assembler <is_file_name.txt> <program_file_name.txt>

<is_file_name.txt> is a file containing a list of all the instructions in blocks. Each block begins with the name of the addressing mode of the instructions that follow it, ending with a colon. The last line of the block always contains the word "end". Example:

single_register_addressing:
INV
DEC
end

<program_file_name_txt> contains all the instructions to be assembled, one for each line.