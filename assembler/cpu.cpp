#include "cpu.hpp"

vector<string> CPU::assemble_instruction(vector<string> instruction){
    string aggregation;
    for (int i = 0; i < instruction.size(); i++){
        aggregation.append(instruction[i]);
    }
    return {aggregation};
}