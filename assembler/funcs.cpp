#include "instr_set.hpp"

instr_set init_set(ifstream stream){
    vector<string> set;
    string value;

    while (stream >> value) set.push_back(value);
    instr_set cpu_set = {set};
    return cpu_set;
}