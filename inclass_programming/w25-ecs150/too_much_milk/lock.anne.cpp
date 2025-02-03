


lock()            // (5)
if(noMilk /* (6) */ && noNote /*(9)*/ ) {
  noNote = false; // 
  unlock();       // 
  buyMilk();      // 
  noMilk = false; // 
  noNote = true;  // 
} else {
  unlock();
}
