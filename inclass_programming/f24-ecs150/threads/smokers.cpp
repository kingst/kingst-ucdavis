Table table;
mutex_t tableLock;
cond_t tableHasItems;
cond_t tableIsEmpty;

void agent() {
  while (true) {
    tableLock.lock();
    while(!table.empty()) {
      wait(tableIsEmpty, tableLock);
    }
    
    items = ["papers", "tobacco", "lighter"];
    table.add(items.randomPop());
    table.add(items.randomPop());

    broadcast(tableHasItems);
    tableLock.unlock(); 
  }
}

void smoker(string item) {
  while (true) {

    tableLock.lock();
    while (table.isEmpty() || table.contains(item)) {
      wait(tableHasItems, tableLock);
    }
    
    items = table.getAllItems();
    items.add(item);

    signal(tableIsEmpty);
    
    tableLock.unlock();
    smoke(items);

    
  }
}

void main() {
  thread_create(smoker, "papers");
  thread_create(smoker, "lighter");
  thread_create(smoker, "tobacco");
  agent();
}
