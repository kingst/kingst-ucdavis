


lock()            // (6)
if(noMilk /* (7) */ && noNote /* 10 */ ) {
  noNote = false; // 
  unlock();       // 
  buyMilk();      // 
  noMilk = false; // 
  noNote = true;  // 
} else {
  unlock();
}

// too much milk
