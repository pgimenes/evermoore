#ifndef INSTR_SET_HPP
#define INSTR_SET_HEPP

#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <algorithm>

using namespace std;

class Instr_Set {
private:
    vector<string> instructions;
    vector< pair< string, vector<string> > > addr_modes;

    void reset_instructions_vect();
public:
    Instr_Set(ifstream & stream);

    void output_instructions(ostream & stream);
    string ret_addr_mode(string instr);
    bool is_instruction(string instr);
};

#endif