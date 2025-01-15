#include <iostream>
#include <string>
#include <string.h>

#include <unistd.h>

using namespace std;

int main(int argc, char *argv[]) {
  int a = 1234;
  char *b = new char[128];
  strcpy(b, "hello world");

  // We're ignoring error checking!
  if (fork() == 0) {
    cout << "child a = " << a << ", b = " << b << ", my pid is " << getpid() << endl;
    char *args[3];
    args[0] = strdup("ls");
    args[1] = strdup("-a");
    args[2] = NULL;
    execvp(args[0], args);
    cout << "Ok, we're done with exec" << endl;
  } else {
    a = 4321;
    cout << "Parent waiting" << endl;
    wait(NULL);
    cout << "parent a = " << a << ", b = " << b << ", my pid is " << getpid() << endl;
  }

  cout << "all done" << endl;
  
  return 0;
}
