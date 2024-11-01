int N = 5;
bool chopstickInUse[] = [false, false, false, false, false];
mutex_t lock;
cond_t chopstickFree;

int leftIdx(int idx) { return idx; }
int rightIdx(int idx) { return (idx + 1) % N; }

void philosopher(int id) {
  while (true) {
    // thinking
    sleep(random());

    // is hungry, grab chopsticks
    lock.lock();
    // grab the left chopstick
    while (chopstickInUse[leftIdx(id)]) {
      wait(chopstickFree, lock);
    }
    chopstickInUse[leftIdx(id)] = true;

    // grab the right chopstick
    while (chopstickInUse[rightIdx(id)]) {
      wait(chopstickFree, lock);
    }
    chopstickInUse[rightIdx(id)] = true; 
    lock.unlock();
    
    //eat
    sleep(random());

    lock.lock();
    chopstickInUse[leftIdx(id)] = false;
    chopstickInUse[rightIdx(id)] = false;
    broadcast(chopstickFree);
    lock.unlock();
  }
}
