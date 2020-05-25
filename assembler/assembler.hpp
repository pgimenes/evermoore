#include "cpu.hpp"

class Assembler {
private:
    vector<string> assembly_code;
    vector<string> parsed_instructions;

    void parse_instructions(CPU & cpu_instance);
    //     // obtain indices of where instruction mnemonics are in the program
    //     vector<int> instr_indices;
    //     for (int i = 0; i < assembly_code.size(); i++){
    //         if (cpu_instance.is_instruction(assembly_code[i])) {
    //             instr_indices.push_back(i);
    //         }
    //     }
    // }
public:
    Assembler(istream & stream, CPU & cpu_instance) {
        string input;
        while (stream >> input) assembly_code.push_back(input);
        parse_instructions(cpu_instance);
    }

    string assemble_instruction();
};