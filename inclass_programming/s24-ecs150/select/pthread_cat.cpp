#include <iostream>
#include <vector>

#include <sys/types.h>
#include <sys/uio.h>
#include <unistd.h>
#include <fcntl.h>
#include <pthread.h>

using namespace std;

struct ThreadArgs {
  int fd;
};

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;

void write_contents_of_file(int fd) {
    unsigned char buffer[4096];
    int ret;

    // read the file until it's done
    while ((ret = read(fd, buffer, sizeof(buffer))) > 0) {
      // you should check for errors!!!
      // threads can do other work outside of this critical section
      // don't assume anything about the order that threads aquire the lock
      pthread_mutex_lock(&lock);
      write(STDOUT_FILENO, buffer, ret);
      pthread_mutex_unlock(&lock);
    }

    close(fd);  
}

void *handle_thread(void *arg) {
  struct ThreadArgs *threadArgs = (struct ThreadArgs *) arg;
  int fd = threadArgs->fd;
  delete threadArgs;
  write_contents_of_file(fd);
  return NULL;
}

int main(int argc, char *argv[]) {
  vector<int> file_descriptors;

  file_descriptors.push_back(STDIN_FILENO);
  for (int idx = 1; idx < argc; idx++) {
    int fd = open(argv[idx], O_RDONLY);
    if (fd < 0) {
      cerr << "could not open " << argv[idx] << endl;
      return 1;
    }
    file_descriptors.push_back(fd);
  }

  // one-by-one print out the contents of our files
  vector<pthread_t> threadIds;
  for (int idx = 0; idx < file_descriptors.size(); idx++) {
    int fd = file_descriptors[idx];
    pthread_t tid;
    struct ThreadArgs *threadArgs = new struct ThreadArgs;
    threadArgs->fd = fd;
    pthread_create(&tid, NULL, handle_thread, threadArgs);
    threadIds.push_back(tid);
    threadArgs = NULL;
  }

  for (int idx = 0; idx < threadIds.size(); idx++) {
    pthread_join(threadIds[idx], NULL);
  }
  
}
