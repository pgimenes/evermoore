#include "cpu.hpp"
#include "assembler.hpp"

using namespace std;

int main(int argc, char ** argv) {
    if (argc=1){
        cerr << "Specify program to be assembled." << endl;
        return 1;
    } else if (argc > 2) {
        cerr << "Too many arguments." << endl;
        return 1;
    } // make it execute on any number of input programs

    string program_file = argv[1];
    
    // create instruction set instance
    ifstream isa_stream ("instructions.txt");
    CPU cpu_instance(isa_stream);
    isa_stream.close();

    // READ PROGRAM
    ifstream program_stream(program_file);
    Assembler program_assembler(program_stream, & cpu_instance);
    program_stream.close();

    // set up output stream and output to MIF
    ofstream output_stream;
    string output_file = argv[2];
    for (int i = 0; i<4; i++) output_file.pop_back();
    output_file.append("_output.txt");
    output_stream.open(output_file);
    program_assembler.assemble();
    program_assembler.output_as_mif(output_stream);

    output_stream.close();

    // FUNCTION TEST LINES
    // cpu_instr_set.output_instructions(cout);
    // cout << cpu_instance.ret_addr_mode("LDI");
}