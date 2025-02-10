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
