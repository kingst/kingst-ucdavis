Table table;

void agent() {
  while (true) {

    
    items = ["papers", "tobacco", "lighter"];
    table.add(items.randomPop());
    table.add(items.randomPop());

    
  }
}

void smoker(string item) {
  while (true) {


    items = table.getAllItems();
    items.add(item);
    
    smoke(items);

    
  }
}

void main() {
  thread_create(smoker, "papers");
  thread_create(smoker, "lighter");
  thread_create(smoker, "tobacco");
  agent();
}
