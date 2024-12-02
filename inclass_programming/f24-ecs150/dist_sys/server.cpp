#include <iostream>
#include <sstream>

#include "MyServerSocket.h"

using namespace std;


int main(int argc, char *argv[]) {
  if (argc != 2) {
    cout << "Usage: " << argv[0] << " port" << endl;
    return 0;
  }

  int port;
  stringstream stream(argv[1]);
  stream >> port;

  MyServerSocket socket(port);

  while (true) {
    MySocket *client = socket.accept();
    cout << "accepted client" << endl;
    string data = client->read();
    cout << "server read: " << data << endl;
    client->write(data);
    delete client;
  }
}
