#include <iostream>
 
#include <fcntl.h>
#include <stdlib.h>
 
#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>

#include <sstream>

using namespace std;

int main(int argc, char *argv[]) {
  int fd;

  if (argc == 1) {
    fd = STDIN_FILENO;
  } else {
    fd = open(argv[1], O_RDONLY);
    if (fd == -1) {
      cerr << "Error opening " << argv[1] << endl;
      return 1;
    }
  }

  int bytesRead = 0;
  char buffer[4096];
  int ret;
  // what is going on with this while loop and buffer???
  while ((ret = read(fd, buffer, sizeof(buffer))) > 0) {
    bytesRead += ret;
  }

  if (ret == -1) {
    cerr << "Error reading file descriptor" << endl;
    return 1;
  }

  // replace this cout call with logic that uses write
  stringstream stringStream;
  stringStream << "Bytes read: " << bytesRead << endl;
  string str = stringStream.str();
  ret = write(STDOUT_FILENO, str.c_str(), str.size());

  if (ret == -1) {
    cerr << "Could not write to STDOUT" << endl;
    return 1;
  }
  
  return 0;
}
