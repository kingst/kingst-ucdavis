#include <iostream>
#include <vector>

#include <stdlib.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <sys/select.h>
#include <fcntl.h>
#include <unistd.h>

using namespace std;

// we're going to ignore error checking to keep this
// example simple, but make sure that you do full
// error checking in any code that you write for
// projects in this class and in general if you want
// to actually use the software.

int main(int argc, char *argv[]) {
  vector<int> fdVector;
  fdVector.push_back(STDIN_FILENO);

  // should set O_NONBLOCK for STDIN, but will skip for simplicity
  for (int idx = 1; idx < argc; idx++) {
    int fd = open(argv[idx], O_RDONLY | O_NONBLOCK);
    fdVector.push_back(fd);
  }

  while (fdVector.size() > 0) {
    fd_set readSet;
    int maxFd = -1;
    FD_ZERO(&readSet);
    
    for (int idx = 0; idx < fdVector.size(); idx++) {
      int fd = fdVector[idx];
      FD_SET(fd, &readSet);
      if (fd > maxFd) {
	maxFd = fd;
      }
    }

    select(maxFd+1, &readSet, NULL, NULL, NULL);

    for (int idx = 0; idx < fdVector.size(); idx++) {
      int fd = fdVector[idx];
      if (FD_ISSET(fd, &readSet)) {
	// we have data ready!!!
	unsigned char buffer[4096];
	int ret = read(fd, buffer, sizeof(buffer));
	if (ret == 0) {
	  close(fd);
	  fdVector.erase(fdVector.begin() + idx);
	  break;
	} else {
	  write(STDOUT_FILENO, buffer, ret);
	}
      }
    }
    
  }

  return 0;
}
