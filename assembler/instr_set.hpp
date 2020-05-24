#include <vector>
#include <string>
#include <iostream>
#include <fstream>

using namespace std;

struct instr_set{
    vector<string> instructions;
};

instr_set init_set(ifstream stream);