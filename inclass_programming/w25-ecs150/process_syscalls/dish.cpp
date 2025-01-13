#include <iostream>
#include <string>
#include <string.h>

#include <unistd.h>

using namespace std;

int main(int argc, char *argv[]) {
  int a = 1234;
  char *b = new char[128];
  strcpy(b, "hello world");

  cout << "before fork pid " << getpid() << endl;
  fork();
  fork();
  cout << "child a = " << a << ", b = " << b << ", my pid is " << getpid() << endl;

  return 0;
}
