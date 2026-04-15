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
  vector<int> fdVec;
  fdVec.push_back(STDIN_FILENO);

  for(int idx = 1; idx < argc; idx++) {
    // important O_NONBLOCK sets up non blocking semantics for the FD
    int fd = open(argv[idx], O_RDONLY | O_NONBLOCK);
    fdVec.push_back(fd);
  }

  while (fdVec.size() > 0) {    
    fd_set readSet;
    int maxFd = -1;
    FD_ZERO(&readSet);

    // set up the data structures needed for select
    for (int idx = 0; idx < fdVec.size(); idx++) {
      int fd = fdVec[idx];
      FD_SET(fd, &readSet);
      if (fd > maxFd) {
	maxFd = fd;
      }
    }

    // blocking call that returns when there are one or more FD ready to read
    select(maxFd + 1, &readSet, NULL, NULL, NULL);

    // find the FD that has data and process it
    // important: we can set policies on priorities
    // Question: Could you implement a policy that reads files
    // completely before moving on?
    for (int idx = 0; idx < fdVec.size(); idx++) {
      int fd = fdVec[idx];
      if (FD_ISSET(fd, &readSet)) {
	char buffer[4096];
	int ret = read(fd, buffer, sizeof(buffer));

	if (ret == 0) {
	  close(fd);
	  fdVec.erase(fdVec.begin() + idx);
	  break;
	} else {
	  write(STDOUT_FILENO, buffer, ret);
	}	
      }
    }
  }
    
  cout << "all done!" << endl;
  
  return 0;
}
