#include "instr_set.hpp"

instr_set::instr_set(ifstream & stream){
    string value;
    while (stream >> value){
        instructions.push_back(value);
    } // instructions initially contains every line of input

    // obtain indexes for begginning and end of each block
    vector<int> start_indexes, end_indexes;

    for (int i = 0; i < instructions.size(); i++){
        string item = instructions[i];
        if (item.back() == ':') start_indexes.push_back(i);
        if (item == "end") end_indexes.push_back(i);
    }

    // assert that start_indexes.size() == end_indexes.size();

    // populate addr_modes vector
    for (int i = 0; i < start_indexes.size(); i++){
        pair<string, vector<string> > block;
        block.first = instructions[start_indexes[i]];

        vector<string> instr_list;
        for (int j = start_indexes[i]+1; j < end_indexes[i]; j++){
            instr_list.push_back(instructions[j]);
        }

        block.second = instr_list;
        addr_modes.push_back(block);
    }
}

void instr_set::output_instructions(ostream & stream){
    for (int i = 0; i < addr_modes.size(); i++){
        // print addresing mode name
        stream << addr_modes[i].first << endl;
        
        // then print out instructions for each addressing mode
        vector<string> & list = addr_modes[i].second;
        for (int j = 0; j < list.size(); j++){
            stream << list[j] << endl;
        }
        stream << endl; // line at the end to separate blocks
    }
}