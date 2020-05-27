#include "instr_set.hpp"

Instr_Set::Instr_Set(ifstream & stream){
    string value;
    while (stream >> value){
        every_input.push_back(value);
    } // every_input initially contains every line of input

    // obtain indexes for begginning and end of each block
    vector<int> start_indexes, end_indexes;

    for (int i = 0; i < every_input.size(); i++){
        string item = every_input[i];
        if (item.back() == ':') start_indexes.push_back(i);
        if (item == "end") end_indexes.push_back(i);
    }

    int start_size = start_indexes.size();
    int end_size = end_indexes.size();

    if (start_size > end_size){
        cerr << "Missing end statement in instructions.txt" << endl;
        exit (1);
    }
    else if (end_size > start_size){
        cerr << "Error in instructions.txt" << endl;
        exit (1);
    }

    // populate map
    for (int i = 0; i < start_indexes.size(); i++){
        string addr_mode_name = every_input[start_indexes[i]];
        addr_mode_name.pop_back();
        for (int j = start_indexes[i]+1; j < end_indexes[i]; j++){
            instr_map.insert(pair<string, string>(every_input[j], addr_mode_name)); // use just this?
        }
    }
}

string Instr_Set::ret_addr_mode(string instr){
    return instr_map.at(instr);
}

bool Instr_Set::is_instruction(string instr){
    if (instr_map.count(instr) == 0) return false;
    else return true;
}