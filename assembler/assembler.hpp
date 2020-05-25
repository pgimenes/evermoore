#include "cpu.hpp"

class Assembler {
private:
    vector<string> assembly_code;
    vector<string> parsed_instructions;

    void parse_instructions(CPU & cpu_instance);
public:
    Assembler(ifstream & stream, CPU & cpu_instance) {
        string input;
        while (stream >> input) assembly_code.push_back(input);
        parse_instructions(cpu_instance);
    }

    string assemble_instruction();
};