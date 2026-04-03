#include <fcntl.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>

#include <iostream>
#include <sstream>

using namespace std;

int main(int argc, char *argv[]) {
    int fd;
    if (argc == 1) {
        fd = STDIN_FILENO;
    } else {
        fd = open(argv[1], O_RDONLY);
        if (fd < 0) {
            cerr << "could not open " << argv[1] << endl;
            return 1;
        }
    }

    char buffer[4096];
    int byteRead = 0;
    int ret;
    while ((ret = read(fd, buffer, 4096)) > 0) {
        byteRead += ret;
    }

    // cout << "Byte count: " << byteRead << endl;
    stringstream ss;
    ss << "Byte count: " << byteRead << endl;
    string str = ss.str();

    ret = write(STDOUT_FILENO, str.c_str(), str.size());

    if (ret == -1) {
        cerr << "Could not write to stdout" << endl;
        return 1;
    }

    return 0;
}
