int N = 5;
bool chopstickInUse[] = [false, false, false, false, false];
mutex_t lock;
cond_t chopstickFree;

int leftIdx(int idx) { return (idx - 1 + N) % N; }
int rightIdx(int idx) { return (idx + 1) % N; }

void philosopher(int id) {
  while (true) {
    // thinking
    sleep(random());

    // is hungry, grab chopsticks
    chopstickInUse[leftIdx(id)] = true;
    chopstickInUse[rightIdx(id)] = true; 

    //eat
    sleep(random());

    chopstickInUse[leftIdx(id)] = false;
    chopstickInUse[rightIdx(id)] = false;
  }
}
