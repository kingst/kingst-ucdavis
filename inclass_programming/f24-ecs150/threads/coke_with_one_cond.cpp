int numCokes = 0;
// assume our capacity is 1 coke
mutex_t cokeLock;
cond_t hasRoomOrCoke;
CokeMachine machine;

void consumer() {
  cokeLock.lock();
  while(!machine.hasCoke()) {
    wait(hasRoomOrCoke, cokeLock);
  }
  machine.removeCoke();
  numCokes--;
  signal(hasRoomOrCoke);
  cokeLock.unlock();
}

void producer() {
  cokeLock.lock();
  while(!machine.hasRoom()) {
    wait(hasRoomOrCoke, cokeLock);
  }
  machine.addCoke();
  numCokes++;
  signal(hasRoomOrCoke);
  cokeLock.unlock();
}
