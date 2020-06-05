#include "assembler.hpp"

string dec_to_hex(string decimal);

void Assembler::assemble(){
    for (int i = 0; i < parsed_instructions.size(); i++){
        // cout << "Instruction " << i+1 << endl;
        vector<string> assembled_instruction = ISA_instance->assemble_instruction(parsed_instructions[i]);
        
        for (int j = 0; j < assembled_instruction.size(); j++){
            assembled_code.push_back(assembled_instruction[j]);
            // cout << assembled_instruction[j] << endl;
        } // normally a single iteration
        // cout << endl;
    }
}

void Assembler::parse_instructions(){
    if (assembly_code.size() == 0) return;
    
    // obtain indices of where instruction mnemonics are in the program
    vector<int> instr_indices;
    for (int i = 0; i < assembly_code.size(); i++){
        if (ISA_instance->is_instruction(assembly_code[i])) {
            instr_indices.push_back(i);
        }
    }
    instr_indices.push_back(assembly_code.size());
    // ERROR HANDLING : WRONG MNEMONICS?

    // combine instructions and parameters into a single vector
    vector<string> instruction;
    for (int i = 0; i < instr_indices.size()-1; i++){
        instruction.clear();
        
        for (int j = instr_indices[i]; j < instr_indices[i+1]; j++){
            instruction.push_back(assembly_code[j]);
        }

        parsed_instructions.push_back(instruction);
    }

    // PRINT parsed_instructions FOR TESTING
    // for (int i = 0; i < parsed_instructions.size(); i++) {
    //     for (int j = 0; j < (parsed_instructions[i]).size(); j++){
    //         cout << (parsed_instructions[i])[j] << " ";
    //     }
    //     cout << endl;
    // }
    // cout << endl;
}

void Assembler::output_as_mif (ofstream & stream){
    stream << "WIDTH=16;" << endl;
    stream << "DEPTH=4096;" << endl;
    stream << endl;
    stream << "ADDRESS_RADIX=UNS;" << endl;
    stream << "DATA_RADIX=BIN;" << endl;
    stream << endl;
    stream << "CONTENT BEGIN" << endl;
    stream << "[0..4095]: 0000000000000000;" << endl;
    for (int i = 0; i < assembled_code.size(); i++){
        stream << dec_to_hex(to_string(i)) << " : ";
        stream << assembled_code[i] << ";" << endl;
    }

    stream << "END;";
}

int Assembler::ret_num_instr () {
    return parsed_instructions.size();
}

string dec_to_hex(string decimal){
    stringstream ss;
    ss << hex << decimal;
    return ss.str();
}

