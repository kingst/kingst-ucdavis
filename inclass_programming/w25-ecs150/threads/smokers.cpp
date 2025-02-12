Table table;
enum Item { papers, lighter, tobacco };

// table has the following methods:
//  - isEmpty
//  - contains
//  - grabAllItems

void agent() {
  while (true) {

    table.add(randomIngredient());
    table.add(randomIngredient());

  }
}

void smoker(int myItem) {
  while (true) {

    vector items = [myItem];
    items.add(table.grabAllItems());

    smoke(items);
  }
}
