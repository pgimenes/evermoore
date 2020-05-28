# curly-lamp

To use the assembler, run the build.sh script. This runs with two test programs program1.txt, and program2.txt and upon execution the output mif file for each will appear in the directory.

To run the program include the programs you want to assemble as command-line parameters:
./assembler <program_file_1.txt> <program_file_2.txt> <...> <program_file_n.txt>

The output will be in mif format which can be directly used with Quartus.

The following files cannot be changed or deleted for the program to run correctly, and they must always be in the same directory as the executable:
- instructions.txt
- instruction_opcodes.txt
- COND_codes.txt

Refer to the link below for a reference of the format of each instruction. Note that the COND field is optional in the assembly and has a default value of "A" (always execute).
https://imperiallondon-my.sharepoint.com/:x:/r/personal/pg519_ic_ac_uk/Documents/instr_set.xlsx?d=w86cb3e3d5c1e4c2a8971e38564a9dc8a&csf=1&web=1&e=mSK1xX

The document below contains an overview of the ISA:
https://imperiallondon-my.sharepoint.com/:w:/r/personal/pg519_ic_ac_uk/Documents/InstructionSet.docx?d=w5f3db266fc9c44efbf8a047937d30a1a&csf=1&web=1&e=Yvnenm
