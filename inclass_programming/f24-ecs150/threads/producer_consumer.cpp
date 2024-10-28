int numCokes = 0;
int maxCokes = 100;
mutex_t cokeLock;
cond_t hasRoom;
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

void producer() {
  cokeLock.lock();

  while (numCokes == maxCokes) {
    wait(hasRoom, cokeLock);
  }

  machine.addCoke();

  numCokes++;
  signal(hasCoke);

  cokeLock.unlock();
}
