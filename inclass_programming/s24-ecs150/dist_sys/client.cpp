#include <iostream>
#include <sstream>

#include "MySocket.h"

using namespace std;


int main(int argc, char *argv[]) {
  if (argc != 3) {
    cout << "Usage: " << argv[0] << " domain port" << endl;
    return 0;
  }

  int port;
  char *domain = argv[1];
  stringstream stream(argv[2]);
  stream >> port;

  MySocket socket = MySocket(domain, port);
  socket.write("some bytes");
  cout << "The server sent us: " << socket.read() << endl;
  
  return 0;
}
