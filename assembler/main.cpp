#include "instr_set.hpp"
#include "cpu.hpp"
#include "assembler.hpp"

using namespace std;

int main(int argc, char ** argv) {
    if (argc==1){
        cerr << "Specify at least one program." << endl;
        return 1;
    }

    // create instruction set instance
    ifstream isa_stream ("instructions.txt");
    CPU cpu_instance(isa_stream);
    isa_stream.close();
    // cout << cpu_instance.register_binary("R7") << endl;

    // execute assemble procedure on each input file
    for (int i = 0; i < argc-1; i++){
        string program_file = argv[i+1];
        
        // READ PROGRAM
        ifstream program_stream(program_file);
        Assembler program_assembler(program_stream, & cpu_instance); // ACTION
        program_stream.close();
        
        // set up output stream and output to MIF
        ofstream output_stream;
        for (int j = 0; j<4; j++) program_file.pop_back();
        program_file.append("_output.txt");
        output_stream.open(program_file);
        
        program_assembler.assemble(); // ACTION
        
        program_assembler.output_as_mif(output_stream); // ACTION

        output_stream.close();

    }
}