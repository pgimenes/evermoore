#ifndef CPU_HPP
#define CPU_HPP

#include "instr_set.hpp"
#include <map>
#include <bitset>
#include <sstream>
#include <cassert>

class CPU
    : public Instr_Set
{
private:
    map<string, string> COND_codes, CIN_codes;
    map<char, string> hex_table;
    map<string, string> instr_opcodes;
public:
    CPU(ifstream & stream);
    vector<string> assemble_instruction(vector<string> instruction_vect);
    string hex_to_binary (string hex_string);
    string register_binary (string reg);
    bool is_cond(string value);

    // ERROR FUNCTIONS
    void assert_reg_specified(vector<string> values);
};

#endif