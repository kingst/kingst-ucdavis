#include <iostream>
#include <vector>

#include <stdlib.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <sys/select.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>

using namespace std;

// we're going to ignore error checking to keep this
// example simple, but make sure that you do full
// error checking in any code that you write for
// projects in this class and in general if you want
// to actually use the software.

void write_file_to_stdout(int fd) {
  char buffer[4096];
  int ret;

  while ((ret = read(fd, buffer, sizeof(buffer))) > 0) {
    write(STDOUT_FILENO, buffer, ret);
  }
  close(fd);
}

struct ThreadArgs {
  int fd;
};

void *threadHandler(void *arg) {
  struct ThreadArgs *threadArgs = (struct ThreadArgs *) arg;
  int fd = threadArgs->fd;
  delete threadArgs;
  threadArgs = NULL;
  write_file_to_stdout(fd);

  return NULL;
}

int main(int argc, char *argv[]) {
  vector<int> fdVec;
  fdVec.push_back(STDIN_FILENO);

  for(int idx = 1; idx < argc; idx++) {
    int fd = open(argv[idx], O_RDONLY);
    fdVec.push_back(fd);
  }

  // loop through each fd one-by-one and print out the contents
  vector<pthread_t> threads;
  for (int idx = 0; idx < fdVec.size(); idx++) {
    int fd = fdVec[idx];
    pthread_t threadId;
    struct ThreadArgs *threadArgs = new struct ThreadArgs;
    threadArgs->fd = fd;
    pthread_create(&threadId, NULL, threadHandler, (void *) threadArgs);
    threadArgs = NULL;
    threads.push_back(threadId);
  }

  for (int idx = 0; idx < threads.size(); idx++) {
    pthread_t threadId = threads[idx];
    pthread_join(threadId, NULL);
  }
  
  cout << "All done!" << endl;
  return 0;
}
