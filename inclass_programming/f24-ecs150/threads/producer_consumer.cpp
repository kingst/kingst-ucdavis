int numCokes = 0;
mutex_t cokeLock;
cond_t hasRoom;
cond_t hasCoke;
CokeMachine machine;

void consumer() {
  cokeLock.lock();


  machine.removeCoke();

  
  cokeLock.unlock();
}

void producer() {
  cokeLock.lock();
  

  machine.addCoke();


  cokeLock.unlock();
}
