#include "cpu.hpp"

CPU::CPU(ifstream & stream)
        : Instr_Set(stream)
{
    hex_table = {{'0', "0000"}, {'1', "0001"}, {'2', "0010"}, {'3', "0011"}, {'4', "0100"}, {'5', "0101"}, {'6', "0110"}, {'7', "0111"}, {'8', "1000"}, {'9', "1001"}, {'A', "1010"}, {'B', "1011"}, {'C', "1100"}, {'D', "1101"}, {'E', "1110"}, {'F', "1111"}, {'a', "1010"}, {'b', "1011"}, {'c', "1100"}, {'d', "1101"}, {'e', "1110"}, {'f', "1111"}};
    
    ifstream cond_stream ("COND_codes.txt");
    create_map(cond_stream, COND_codes);

    // OBTAIN SPECIFIC INSTRUCTION OPCODES
    ifstream opcode_stream("instruction_opcodes.txt");
    create_map (opcode_stream, instr_opcodes);
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


    // cout << addr_mode << endl;
    // cout << "size: " << size << endl;
    assert(size > 0 && size < 6);
    
    // direct addressing is unconditional
    if (addr_mode == "direct_addressing") {
        assembled_string.append(hex_to_binary(instruction_vect[1]));
        assembled_vect.push_back(assembled_string);
        return assembled_vect;
    }
    else if (addr_mode == "control_ops" && size == 1){
        assembled_string.append(condition_binary);
        assembled_vect.push_back(assembled_string);
        return assembled_vect;
    }

    // see if COND is specified
    if (is_cond(instruction_vect[1])){
        condition_binary = COND_codes.at(instruction_vect[1]);
    }
    assembled_string.append(condition_binary);

    // include rest of instruction
    if (addr_mode == "single_reg"){
        assert_reg_specified({instruction_vect[size-1]});
        assembled_string.append(register_binary(instruction_vect[size-1])); 
    }
    else if (addr_mode == "single_reg_immediate") {
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_vect.push_back(assembled_string);
        assembled_vect.push_back(hex_to_binary(instruction_vect[size-1], "16b"));
        return assembled_vect;
    }
    else if(addr_mode == "single_reg_bit_access") {
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_string.append(hex_to_binary(instruction_vect[size-1])); 
    }
    else if (addr_mode == "double_reg") {
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_string.append(register_binary(instruction_vect[size-1]));
    }
    else if (addr_mode == "triple_reg"){
        assembled_string.append(register_binary(instruction_vect[size-3]));
        assembled_string.append(register_binary(instruction_vect[size-2]));
        assembled_string.append(register_binary(instruction_vect[size-1]));
    }
    else if (addr_mode == "control_ops_offset"){
        assembled_string.append(hex_to_binary(instruction_vect[size-1], "3b"));
    }
    
    assembled_vect.push_back(assembled_string);
    return assembled_vect;
}

string CPU::hex_to_binary (string hex_string, string spec){
    string input, output;
    input = hex_string;
    if (input[0] == '0' && input[1] == 'x') for (int i = 0; i < 2; i++) input.erase(input.begin());

    if (input.size() > 4) {
        cerr << "HEX data out of range." << endl;
        exit(1);
    }

    for (int i = 0; i < input.size(); i++){
        output.append(hex_table.at(input[i]));
    }

    if (spec=="3b") {
        output.erase(output.begin());
    } else if (spec=="16b"){
        // if less than 4 hex digits specified, add 0's to the left to complete 16 binary bits
        for (int i = 0; i < (4-input.size()); i++) {
            output.insert (0, "0000");
        }
    }
    return output;
}


string CPU::register_binary (string reg){
    string reg_num = reg;
    reg_num.erase(reg_num.begin());
    bitset<3> bin (stoi(reg_num));
    return bin.to_string();
}

bool CPU::is_cond(string value){
    if (COND_codes.count(value) == 0) return false;
    else return true;
}

void CPU::assert_reg_specified (vector<string> values){
    bool assertion = true;
    string message;

    for (int i = 0; i < values.size(); i++) {
        if (values[i][0] != 'R' && values[i][0] != 'r') {
            assertion = false;
            message = "Invalid syntax. Specify register.";
            break;
        }

        string num = values[i];
        num.erase(num.begin());
        if (stoi(num) > 7){
            assertion = false;
            message = "Register out of range.";
        }
    }

    if (!assertion){
        cerr << message << endl;
        exit(1);
    }
}