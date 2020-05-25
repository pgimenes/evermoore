#include "cpu.hpp"
#include "assembler.hpp"

using namespace std;

int main(int argc, char ** argv) {
    if (argc!=3){
        cerr << "Invalid number of arguments." << endl;
        return 1;
    }

    string isa_file = argv[1];
    string program_file = argv[2];
    
    // create CPU object from instruction file
    ifstream isa_stream (isa_file);
    CPU cpu_instance(isa_stream);
    isa_stream.close();

    // FUNCTION TEST LINES
    // cpu_instr_set.output_instructions(cout);
    // cout << cpu_instance.ret_addr_mode("BRAD");

    // READ PROGRAM
    ifstream program_stream(program_file);
    Assembler program_assembler(program_stream, cpu_instance);
    program_stream.close();
}