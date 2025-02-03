bool noMilk = true;
bool noNote = true;

lock()            // (1)
if(noMilk && noNote) {
  noNote = false; // (2)
  unlock();       // (3)
  buyMilk();      // (4)
  noMilk = false; // (7)
  noNote = true;  // (8)
} else {
  unlock();
}
