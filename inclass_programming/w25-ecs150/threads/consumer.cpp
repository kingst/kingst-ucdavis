int numCokes = 0;
int maxCokes = 100;
mutex_t cokeLock;
// wait until hasRoom
cond_t hasRoom;
// wait until hasCoke
cond_t hasCoke;
CokeMachine machine;

void consumer() {
  cokeLock.lock();

  while (numCokes == 0) {
    wait(hasCoke, cokeLock);
  }
  
  machine.removeCoke();
  numCokes--;
  signal(hasRoom);
  
  cokeLock.unlock();
}
