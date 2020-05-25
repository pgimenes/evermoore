#ifndef INSTR_SET_HPP
#define INSTR_SET_HEPP

#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <map>

using namespace std;

class Instr_Set {
private:
    vector<string> instructions;
    vector< pair< string, vector<string> > > addr_modes;
    map<string, string> instr_map;

    void reset_instructions_vect();
public:
    Instr_Set(ifstream & stream);

    void output_instr_blocks(ostream & stream);
    // string ret_addr_mode(string instr);
    bool is_instruction(string instr);

    virtual vector<string> assemble_instruction(vector<string> instruction) =0;
    // convert to binary, specific to each instruction set
    // return vector will normally have size 1 except for instructions with 16-bit direct data
};

#endif