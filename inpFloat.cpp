#include <iostream>
#include <iomanip>
#include <cstdlib>
// #include <cmath>
// #include <string>
#include <sstream>
#include <fstream>
// #include <queue>
// #include <stack>
using namespace std;


int main(int argc, char** argv) {
    fstream s("FLOAT10.BIN", ios::in | ios::binary);

    if (!s) {
      cout << "Cannot open file!" << endl;
      return 1;
   }

    float array[15];
    for(int i = 0; i < 10; i++)
        s.read((char *) &array[i], sizeof(float));

    for(int i = 0; i < 10; i++)
        cout << array[i] << " ";

    s.close();
    return 0;
}