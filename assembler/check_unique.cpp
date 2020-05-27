#include <fstream>
#include <vector>
#include <string>
#include <iostream>

using namespace std;

int main(){
    fstream file ("instructions.txt");
    vector<string> vect;
    string input;
    while (file >> input) vect.push_back(input);

    bool all_unique = true;

    for (int i = 0; i < vect.size(); i++){
        for (int j = 0; j < vect.size(); j++){
            if (i == j) continue;
            if (vect[i] == vect[j]) all_unique = false;
        }
    } // highly inefficient

    cout << all_unique << endl;
}