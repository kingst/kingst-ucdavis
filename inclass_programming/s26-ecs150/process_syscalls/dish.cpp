#include <string.h>
#include <unistd.h>

#include <iostream>
#include <string>

using namespace std;

int main(int argc, char* argv[]) {
    int a = 1234;
    char* b = new char[128];
    strcpy(b, "hello world!");

    pid_t ret = fork();

    if (ret < 0) {
        cerr << "Error, cannot call fork" << endl;
        return 0;
    } else if (ret == 0) {
        // this is the child;
        cout << "Child  a = " << a << ", b = " << b << ", my pid = " << getpid() << endl;
    } else {
        cout << "Parent a = " << a << ", b = " << b << ", my pid = " << getpid() << endl;
    }

    return 0;
}