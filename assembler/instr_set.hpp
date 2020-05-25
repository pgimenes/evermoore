#include <vector>
#include <string>
#include <iostream>
#include <fstream>

using namespace std;

class instr_set {
private:
    vector<string> instructions;
    vector< pair< string, vector<string> > > addr_modes;

public:
    instr_set(ifstream & stream);

    void output_instructions(ostream & stream);
};