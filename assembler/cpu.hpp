#ifndef CPU_HPP
#define CPU_HPP

#include "instr_set.hpp"
#include <map>

class CPU
    : public Instr_Set
{
private:
    map<string, string> COND_codes, CIN_codes, AM_codes;
public:
    CPU(ifstream & stream)
        : Instr_Set(stream)
        {
            COND_codes = {{"ZS", "0000"}, {"NS","0001"}, {"CS","0010"}, {"TS","0011"}, {"VS", "0100"}, {"SS", "0101"}, {"A", "0110"}, {"IS", "0111"}, {"ZC", "1000"}, {"NC", "1001"}, {"CC", "1010"}, {"TC", "1011"}, {"VC", "1100"}, {"SC", "1101"}, {"IC", "1111"}};
            CIN_codes = {{"CIZ", "00"}, {"CIO", "01"}, {"CIF", "10"}, {"CIL", "11"}};
            AM_codes = {{"single_register", "00"}, {"double_register", "01"}, {"triple_register", "10"}, {"direct_addressing_control_ops", "11"}};
        }

    string assemble_instr();
};

#endif