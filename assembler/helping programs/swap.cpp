#include <fstream>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

int main(){
    ifstream in_file ("instruction_opcodes.txt");
    vector<string> content;

    string key;
    while (in_file >> key){
        key.pop_back();
        content.push_back(key);
        
        string value, end_statement;
        in_file >> value >> end_statement;
        content.push_back(value);
        content.push_back(end_statement);
    }

    ofstream out_file("instruction_opcodes_swapped.txt");

    for (int i = 0; i < content.size(); i += 3) {
        out_file << content[i+1] << ": ";
        out_file << content[i] << " ";
        out_file << content[i+2] << endl;
    }
}