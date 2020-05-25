#include "instr_set.hpp"

using namespace std;

int main(int argc, char ** argv) {
    if (argc!=3){
        cerr << "Invalid number of arguments." << endl;
        return 1;
    }

    string isa_file = argv[1];
    string program_file = argv[2];
    
    // create instr_set object from instruction file
    ifstream isa_stream (isa_file);
    instr_set cpu_instr_set(isa_stream);
    isa_stream.close();

    cpu_instr_set.output_instructions(cout);
}