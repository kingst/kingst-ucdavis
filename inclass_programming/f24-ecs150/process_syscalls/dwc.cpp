#include <iostream>
 
#include <fcntl.h>
#include <stdlib.h>
 
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>

#include <sstream>

using namespace std;

int main(int argc, char *argv[]) {
  int fileDescriptor;

  if (argc == 1) {
    // no arguments, use STDIN
    fileDescriptor = STDIN_FILENO;
  } else {
    fileDescriptor = open(argv[1], O_RDONLY);
    if (fileDescriptor == -1) {
      cerr << "Could not open " << argv[1] << endl;
      return 1;
    }
  }

  int ret;
  int bytesRead = 0;
  char buffer[4096];

  // what's going on with the while loop and buffer[4096]
  while ((ret = read(fileDescriptor, buffer, sizeof(buffer))) > 0) {
    bytesRead += ret;
  }

  if (fileDescriptor != STDIN_FILENO) {
    close(fileDescriptor);
  }

  // Break into groups! Replace cout with a call to `write`
  stringstream stringOut;
  stringOut << "Bytes read: " << bytesRead << endl;
  string str = stringOut.str();

  write(STDOUT_FILENO, str.c_str(), str.length());
  
  return 0;
  
  
}
