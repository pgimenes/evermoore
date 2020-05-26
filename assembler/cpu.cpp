#include "cpu.hpp"

CPU::CPU(ifstream & stream)
        : Instr_Set(stream)
        {
            COND_codes = {{"ZS", "0000"}, {"NS","0001"}, {"CS","0010"}, {"TS","0011"}, {"VS", "0100"}, {"SS", "0101"}, {"A", "0110"}, {"IS", "0111"}, {"ZC", "1000"}, {"NC", "1001"}, {"CC", "1010"}, {"TC", "1011"}, {"VC", "1100"}, {"SC", "1101"}, {"IC", "1111"}};
            CIN_codes = {{"CIZ", "00"}, {"CIO", "01"}, {"CIF", "10"}, {"CIL", "11"}};
            hex_table = {{'0', "0000"}, {'1', "0001"}, {'2', "0010"}, {'3', "0011"}, {'4', "0100"}, {'5', "0101"}, {'6', "0110"}, {'7', "0111"}, {'8', "1000"}, {'9', "1001"}, {'A', "1010"}, {'B', "1011"}, {'C', "1100"}, {'D', "1101"}, {'E', "1110"}, {'F', "1111"}, {'a', "1010"}, {'b', "1011"}, {'c', "1100"}, {'d', "1101"}, {'e', "1110"}, {'f', "1111"}};

            // OBTAIN SPECIFIC INSTRUCTION OPCODES
            ifstream opcode_stream("instruction_opcodes.txt");
            string input;
            
            // idk if this implementation will work:
            // while (opcode_stream >> input){
            //     if (is_instruction(input)) {
            //         string opcode;
            //         opcode_stream >> opcode;
            //         instr_opcodes.insert(pair<string, string>(input, opcode));
            //     }
            // }
            // map<string,string>::iterator it;
            // for (it = instr_opcodes.begin(); it < instr_opcodes.end(); it++){
            //     cout << it->first << endl;
            // }
            
            vector<string> opcode_input;
            while (opcode_stream >> input) opcode_input.push_back(input);
            opcode_stream.close();

            for (int i = 0; i < opcode_input.size(); i++){
                if (is_instruction(opcode_input[i])) {
                    instr_opcodes.insert(pair<string, string>(opcode_input[i], opcode_input[i+1]));
                }
            }
        }

// receives instruction in vector form and returns binary in vect form where each element is a RAM address value
vector<string> CPU::assemble_instruction(vector<string> instruction_vect){
    vector<string> assembled_vect;
    string assembled_string;
    
    // instruction parameters
    int size = instruction_vect.size();  
     
    string addr_mode = ret_addr_mode(instruction_vect[0]);
    string condition_binary = COND_codes.at("A"); // set to ALWAYS by default.
    
    // insert instruction OPCODE
    assembled_string = instr_opcodes.at(instruction_vect[0]);
    
    // direct addressing is unconditional
    if (addr_mode == "direct_addressing") {
        assembled_string.append(hex_to_binary(instruction_vect[1]));
        assembled_vect.push_back(assembled_string);
        return assembled_vect;
    }
    if (is_cond(instruction_vect[1])) condition_binary = COND_codes.at(instruction_vect[1]);

    if (addr_mode == "single_reg"){
        assembled_string.append(register_binary(instruction_vect[size-1]));
    }
    else if (addr_mode == "single_reg_immediate" || addr_mode == "single_reg_bit_access") {
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_string.append(hex_to_binary(instruction_vect[size-1])); 
    }
    else if (addr_mode == "double_reg_arithmetic") {
        assembled_string.append(CIN_codes.at(instruction_vect[size-3]));
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_string.append(register_binary(instruction_vect[size-1]));
    }
    else if (addr_mode == "double_reg_non_arithmetic"){
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_string.append(register_binary(instruction_vect[size-1]));
    }
    else if (addr_mode == "triple_reg"){
        assembled_string.append(register_binary(instruction_vect[size-3]));
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_string.append(register_binary(instruction_vect[size-1]));
    }
    else if (addr_mode == "control_ops_offset"){
        assembled_string.append(hex_to_binary(instruction_vect[size-1]));
    }
    
    return assembled_vect;
}

string CPU::hex_to_binary (string hex_string){
    string input, output;
    input = hex_string;
    if (input[0] == '0' && input[1] == 'x'){
        for (int i = 0; i < 2; i++) input.erase(input.begin());
    }
    for (int i = 0; i < input.size(); i++){
        output.append(hex_table.at(input[i]));
    }
    return output;
}


string CPU::register_binary (string reg){
    if (reg[0] != 'R' && reg[0] != 'r') return "Invalid syntax."; // create system to evaluate errors?
    reg.erase(reg.begin());
    bitset<3> bin (reg);
    return bin.to_string();
}

bool CPU::is_cond(string value){
    if (COND_codes.count(value) == 0) return false;
    else return true;
}