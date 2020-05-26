#include "cpu.hpp"
#include <bitset>
#include <sstream>

vector<string> CPU::assemble_instruction(vector<string> instruction){
    return instruction;
}

string CPU::hex_to_binary (string hex_string){
    stringstream ss;
    ss << hex << hex_string;
    
    // unsigned n;
    // ss >> n;
    // bitset<size> b(n);
    // return b.to_string();
    return hex_string;
}