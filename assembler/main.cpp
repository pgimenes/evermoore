#include "instr_set.hpp"

using namespace std;

int main(int argc, char ** argv) {
    //
    ifstream instr_file;
    instr_file.open("instructions.txt");
    instr_set cpu_instr_set = init_set(instr_file);
    instr_file.close();

    for (int i = 0; i < cpu_instr_set.instructions.size(); i++){
        cout << cpu_instr_set.instructions[i] << endl;
    }
}