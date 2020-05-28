#include "instr_set.hpp"

Instr_Set::Instr_Set(ifstream & stream)
    : ISA_file_stream(stream)
{
    // CREATE INSTRUCTION MAP
    create_map(ISA_file_stream, instr_map);
}

void Instr_Set::create_map (ifstream & stream, map<string, string> & container){
    string input;
    vector<string> every_input;

    while (stream >> input){
        every_input.push_back(input);
    }

    // obtain indexes for begginning and end of each block
    vector<int> start_indexes, end_indexes;
    for (int i = 0; i < every_input.size(); i++){
        string item = every_input[i];
        if (item.back() == ':') start_indexes.push_back(i);
        if (item == "end") end_indexes.push_back(i);
    }

    // ERROR HANDLING
    int start_size = start_indexes.size();
    int end_size = end_indexes.size();
    if (start_size > end_size){
        cerr << "Missing end in specification file." << endl;
        exit (1);
    }
    else if (end_size > start_size){
        cerr << "Error in specification file" << endl;
        exit (1);
    }

    // POPULATE MAP
    for (int i = 0; i < start_indexes.size(); i++){
        string value = every_input[start_indexes[i]]; // addressing mode is the mapped value
        value.pop_back();

        // add every key with the same mapped value
        for (int j = start_indexes[i]+1; j < end_indexes[i]; j++){
            string key = every_input[j];
            container.insert(pair<string, string>(key, value));

            // include lower case variation of key
            string lower_case = key;
            transform(lower_case.begin(), lower_case.end(), lower_case.begin(), ::tolower);
            container.insert(pair<string, string> (lower_case, value));
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
