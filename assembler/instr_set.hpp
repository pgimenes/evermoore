#ifndef INSTR_SET_HPP
#define INSTR_SET_HPP

#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <map>

using namespace std;

class Instr_Set {
private:
    vector<string> every_input;
    map<string, string> instr_map;
public:
    Instr_Set(ifstream & stream);

    virtual vector<string> assemble_instruction(vector<string> instruction) =0;
    // convert to binary, specific to each instruction set
    // return vector will normally have size 1 except for instructions with 16-bit direct data

    string ret_addr_mode(string instr);
    bool is_instruction(string instr);
};

#endif