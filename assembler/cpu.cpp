#include "cpu.hpp"
#include <bitset>
#include <sstream>

vector<string> CPU::assemble_instruction(vector<string> instruction){
    string aggregation;
    for (int i = 0; i < instruction.size(); i++){
        aggregation.append(instruction[i]);
    }
    return {aggregation};
}

string CPU::hex_to_binary (string hex_string){
    stringstream ss;
    ss << hex << hex_string;
    
    unsigned n;
    ss >> n;
    bitset<size> b(n);
    return b.to_string();
}