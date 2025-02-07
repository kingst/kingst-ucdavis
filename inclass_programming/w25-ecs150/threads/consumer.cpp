int numCokes = 0;
int maxCokes = 100;
mutex_t cokeLock;
cond_t hasRoom;
cond_t hasCoke;
CokeMachine machine;

void consumer() {
  cokeLock.lock();

  machine.removeCoke();
  numCokes--;
  
  cokeLock.unlock();
}
