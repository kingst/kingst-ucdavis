bool noMilk = true;
bool noNote = true;

lock()            // (1)
if(noMilk && noNote) { // (2)
  noNote = false; // (3)
  unlock();       // (4)
  buyMilk();      // (5)
  noMilk = false; // (8)
  noNote = true;  // (9)
} else {
  unlock();
}
