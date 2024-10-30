int numCokes = 0;
int maxCokes = 1;
// assume our capacity is 1 coke
mutex_t cokeLock;
cond_t hasRoomOrCoke;
CokeMachine machine;

void consumer() {
  cokeLock.lock();
  while(numCokes == 0) {
    wait(hasRoomOrCoke, cokeLock);
  }
  machine.removeCoke();
  numCokes--;
  signal(hasRoomOrCoke);
  cokeLock.unlock();
}

void producer() {
  cokeLock.lock();
  while(numCokes == maxCokes) {
    wait(hasRoomOrCoke, cokeLock);
  }
  machine.addCoke();
  numCokes++;
  signal(hasRoomOrCoke);
  cokeLock.unlock();
}
