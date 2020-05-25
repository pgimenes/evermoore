#include "cpu.hpp"

class Assembler {
private:
    vector<string> assembly_code;
    vector<vector<string>> parsed_instructions;
    vector<string> assembled_code; // in binary

    Instr_Set * ISA_instance;

    void parse_instructions(Instr_Set * isa_instance);
public:
    // upon construction, object reads program and 
    Assembler(ifstream & stream, Instr_Set * isa_instance) // can't use reference instead of pointer?
        : ISA_instance(isa_instance)
    {
        string input;
        while (stream >> input) assembly_code.push_back(input);
        parse_instructions(ISA_instance); // separates program instructions
    }

    void assemble(); // takes all parsed instructions and converts to assembled binary

    void output_as_mif (ofstream & stream);
};