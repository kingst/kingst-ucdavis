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
  }
  
}
