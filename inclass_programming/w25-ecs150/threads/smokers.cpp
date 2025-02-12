Table table;
enum Item { papers, lighter, tobacco };
bool isSmoking = false;
cond_t tableEmpty;
cond_t canSmoke;
mutex_t lock;

// table has the following methods:
//  - isEmpty
//  - contains
//  - grabAllItems

void agent() {
  lock.lock();
  while (true) {

    while (!table.isEmpty() || isSmoking) {
      wait(lock, tableEmpty);
    }
    
    vector items = [papers, ligher, tobacco];
    table.add(items.randomPop());
    table.add(items.randomPop());

    broadcast(canSmoke);
    
  }
  lock.unlock();
}

void smoker(Item myItem) {
  lock.lock();
  while (true) {

    while (table.contains(myItem) || table.isEmpty()) {
      wait(canSmoke, lock);
    }
    
    vector items = [myItem];
    items.add(table.grabAllItems());
    isSmoking = true;
    lock.unlock();
    
    smoke(items);

    lock.lock();
    signal(tableEmpty);
    isSmoking = false;
  }
  lock.unlock();
}
