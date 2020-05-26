#include "assembler.hpp"

void Assembler::assemble(){
    for (int i = 0; i < parsed_instructions.size(); i++){
        vector<string> assembled_instruction = (*ISA_instance).assemble_instruction(parsed_instructions[i]);
        
        for (int j = 0; j < assembled_instruction.size(); j++){
            assembled_code.push_back(assembled_instruction[j]);
            cout << assembled_instruction[j] << endl;
        } // normally a single iteration
    }
}

void Assembler::parse_instructions(Instr_Set * isa_instance){
    // obtain indices of where instruction mnemonics are in the program
    vector<int> instr_indices;
    for (int i = 0; i < assembly_code.size(); i++){
        if ((*isa_instance).is_instruction(assembly_code[i])) {
            instr_indices.push_back(i);
        }
    }
    instr_indices.push_back(assembly_code.size());

    // combine instructions with specifiers into a single vector
    vector<string> instruction;
    for (int i = 0; i < instr_indices.size()-1; i++){
        instruction.clear();
        
        for (int j = instr_indices[i]; j < instr_indices[i+1]; j++){
            instruction.push_back(assembly_code[j]);
        }

        parsed_instructions.push_back(instruction);
    }

    // PRINT parsed_instructions FOR TESTING
    for (int i = 0; i < parsed_instructions.size(); i++) {
        for (int j = 0; j < (parsed_instructions[i]).size(); j++){
            cout << (parsed_instructions[i])[j] << " ";
        }
        cout << endl;
    }
    cout << endl;
}

void Assembler::output_as_mif (ofstream & stream){
    for (int i = 0; i < assembled_code.size(); i++){
        stream << i << " : ";
        stream << assembled_code[i] << endl;
    }
}