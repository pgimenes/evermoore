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

    assert(size > 0 && size < 6);
    
    // direct addressing is unconditional
    if (addr_mode == "direct_addressing") {
        assembled_string.append(hex_to_binary(instruction_vect[1], 3));
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

    vector<string> instr_registers;
    // include rest of instruction
    if (addr_mode == "single_reg"){
        instr_registers = register_binary({instruction_vect[size-1]});
        assembled_string.append(instr_registers[0]); 
    }
    else if (addr_mode == "single_reg_immediate") {
        instr_registers = register_binary( {instruction_vect[size-2]} );
        assembled_string.append(instr_registers[0]);
        assembled_vect.push_back(assembled_string);
        assembled_vect.push_back(hex_to_binary(instruction_vect[size-1], 4));
        return assembled_vect;
    }
    else if(addr_mode == "single_reg_bit_access") {
        instr_registers = register_binary({instruction_vect[size-2]});
        assembled_string.append(instr_registers[0]);
        assembled_string.append(hex_to_binary(instruction_vect[size-1], 1)); 
    }
    else if (addr_mode == "double_reg") {
        instr_registers = register_binary({instruction_vect[size-2], instruction_vect[size-1]});
        for (int i = 0; i<instr_registers.size(); i++) assembled_string.append(instr_registers[i]);
    }
    else if (addr_mode == "triple_reg"){
        instr_registers = register_binary({instruction_vect[size-3], instruction_vect[size-2], instruction_vect[size-1]});
        for (int i = 0; i<instr_registers.size(); i++) assembled_string.append(instr_registers[i]);
    }
    else if (addr_mode == "control_ops_offset"){
        assembled_string.append(hex_to_binary(instruction_vect[size-1], 0));
    }
    assembled_vect.push_back(assembled_string);
    return assembled_vect;
}

// lim is the number of hex digits the equivalent output binary has = output.size()/4
string CPU::hex_to_binary (string hex_string, int lim){
    string output;
    hex_string = hex_string;
    if (hex_string[0] == '0' && (hex_string[1] == 'x' || hex_string[1] == 'X')) for (int i = 0; i < 2; i++) hex_string.erase(hex_string.begin());

    // obtain equivalent binary for each hex digit
    for (int i = 0; i < hex_string.size(); i++){
        output.append(hex_table.at(hex_string[i]));
    }
    
    if (lim == 0) {
        output.erase(output.begin());
        return output;
    } // this case is used for when a 3-bit binary is needed

    if (hex_string.size() > lim) call_error_msg ("HEX data out of range");

    for (int i = 0; i < (lim-hex_string.size()); i++) {
        output.insert (0, "0000");
    }
    
    if (lim == 0) output.erase(output.begin());

    return output;
}


vector<string> CPU::register_binary (vector<string> registers){
    assert_reg_specified(registers);
    vector<string> binary_registers;
    for (int i = 0; i < registers.size(); i++){
        string reg_num = registers[i];
        reg_num.erase(reg_num.begin());
        bitset<3> bin (stoi(reg_num));
        binary_registers.push_back(bin.to_string());
    }
    return binary_registers;
}

bool CPU::is_cond(string value){
    if (COND_codes.count(value) == 0) return false;
    else return true;
}

// assert register has correct syntax and is in range
void CPU::assert_reg_specified (vector<string> values){
    bool assertion = true;
    string message;

    for (int i = 0; i < values.size(); i++) {
        if (values[i][0] != 'R' && values[i][0] != 'r') {
            assertion = false;
            message = "Invalid syntax. Specify register.";
        }

        string num = values[i];
        num.erase(num.begin());
        if (stoi(num) > 7){
            assertion = false;
            message = "Register out of range.";
        }
    }

    if (!assertion){
        call_error_msg(message);
    }
}

void CPU::call_error_msg (string message){
    cerr << "HEX data out of range." << endl;
    exit(1);
}
