#include "assembler.hpp"

void Assembler::parse_instructions(CPU & cpu_instance){
    // obtain indices of where instruction mnemonics are in the program
        vector<int> instr_indices;
        for (int i = 0; i < assembly_code.size(); i++){
            if (cpu_instance.is_instruction(assembly_code[i])) {
                instr_indices.push_back(i);
            }
        }
}

// string Assembler::assemble_instruction(){
// }