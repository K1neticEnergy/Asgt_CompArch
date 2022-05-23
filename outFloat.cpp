#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <string>
#include <sstream>
#include <fstream>
#include <queue>
#include <stack>
using namespace std;


int main(int argc, char** argv) {
    fstream s("FLOAT10.BIN", ios::out | ios::binary);

    float array[10] = {2.4f, 6.1f, 3.5f, 9.4f, 2.1f, -1.4f, -6.0f, -0.98f, 10.4543f, 3.6f};

    for(int i = 0; i < 10; i++)
        s.write((char *) &array[i], sizeof(float));

    s.close();
    return 0;
}