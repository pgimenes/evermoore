#include "instr_set.hpp"
#include "cpu.hpp"
#include "assembler.hpp"

using namespace std;

int main(int argc, char ** argv) {
    if (argc==1){
        cerr << "Specify at least one program." << endl;
        exit(1);
    }

    // CREATE INSTRUCTION SET INSTANCE
    ifstream isa_stream ("instructions.txt");
    CPU cpu_instance(isa_stream);
    isa_stream.close();

    // EXECUTE ASSEMBLE PROCEDURE FOR EACH FILE
    for (int i = 1; i < argc; i++){
        string program_file = argv[i];
        cout << "Assembling " << program_file << " ..." << endl;
        
        // READ PROGRAM
        ifstream program_stream(program_file);
        Assembler program_assembler(program_stream, & cpu_instance); // ACTION
        program_stream.close();
        
        // ASSERT FILE NOT EMPTY
        if (program_assembler.ret_num_instr() == 0) {
            cerr << "Check file name." << endl;
            cerr << "Either name incorrect or file empty." << endl << endl;
            continue;
        }
        
        // SET UP OUTPUT STREAM
        ofstream output_stream;
        // if there is an extension, replace it with .mif
        if (program_file[program_file.size()-4] == '.'){
            for (int j = 0; j<4; j++) program_file.pop_back();
        }
        program_file.append("_assembled.mif");
        output_stream.open(program_file);
        
        // PERFORM ASSEMBLING AND OUTPUT
        program_assembler.assemble();
        
        program_assembler.output_as_mif(output_stream);

        output_stream.close();

        cout << "Done." << endl;
        cout << endl;
    }
}