#include <iostream>
#include <string>
#include <string.h>

#include <unistd.h>

using namespace std;

int main(int argc, char *argv[]) {
  int a = 1234;
  char *b = new char[128];
  int c = 4321;
  
  strcpy(b, "Hello world");

  pid_t ret = fork();

  if (ret < 0) {
    cerr << "error!" << endl;
    return 1;
  } else if (ret == 0) {
    // this is the child
    char *args[3];
    args[0] = strdup("ls");
    args[1] = strdup("-a");
    args[2] = NULL;
    execvp(args[0], args);
    
    c = a;
    cout << "Child: " << a << ", " << b << ", c= " << c << ", my pid is " << getpid() << endl;
  } else {
    // this is the parent
    cout << "before wait" << endl;
    int ret = wait(NULL);
    cout << "Parent: " << a << ", " << b << ", my pid is " << getpid() << ", wait ret = " << ret << endl;
  }
  
}
