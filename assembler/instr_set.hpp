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
    map<string, string> instr_map;
    ifstream & ISA_file_stream;
public:
    Instr_Set(ifstream & stream);

    virtual vector<string> assemble_instruction(vector<string> instruction) =0;
    // convert to binary, specific to each instruction set
    // return vector will normally have size 1 except for instructions with 16-bit direct data

    void create_map (ifstream & stream, map<string, string> & container);
    // reads a file containing lists with a header
    // inserts each member in each list to the map as a key, where the mapped value is the list header
    // includes lower case version of each item

    string ret_addr_mode(string instr);
    bool is_instruction(string instr);
};

#endif