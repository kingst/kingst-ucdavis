int numReaders = 0;
int writersWaiting = 0;
bool writerActive = false;
mutex_t lock;
cond_t unlockCalled;

void reader() {
  lock.lock();
  while (writerActive || writersWaiting > 0) {
    wait(unlockCalled, lock);
  }

  numReaders++;
  unlock();
}

void writer() {
  lock.lock();
  writersWaiting++;
  while (numReaders > 0 || writerActive) {
    wait(unlockCalled, lock);
  }
  writersWaiting--;
  writerActive = true;
  lock.unlock();
}

void unlock() {
  lock.lock();
  if (numReaders > 0) {
    numReaders--;
  } else {
    writerActive = false;
  }
  broadcast(unlockCalled);
  lock.unlock();
}
