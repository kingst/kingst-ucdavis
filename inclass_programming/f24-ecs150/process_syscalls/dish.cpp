#include <iostream>
#include <string>
#include <string.h>

#include <unistd.h>

using namespace std;

int main(int argc, char *argv[]) {
  int a = 1234;
  char *b = new char[128];
  strcpy(b, "hello world");

  int ret = fork();
  if (ret < 0) {
    cerr << "Error calling fork" << endl;
    return 1;
  } else if (ret == 0) {
    char *args[3];
    args[0] = (char *) "ls";
    args[1] = (char *) "-a";
    args[2] = NULL;
    execvp(args[0], args);
    // you know you have an error
    // child
    a = 4321;
    cout << "child a = " << a << ", b = " << b << ", my pid is " << getpid() << endl;
  } else {
    // parent
    cout << "Waiting for child" << endl;
    pid_t child = wait(NULL);
    cout << "parent a = " << a << ", b = " << b << ", my pid is " << getpid() << ", child pid = " << child << endl;
  }
  return 0;
}
