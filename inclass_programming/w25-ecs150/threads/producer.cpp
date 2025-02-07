void producer() {
  cokeLock.lock();

  machine.addCoke();
  numCokes++;

  cokeLock.unlock();
}
