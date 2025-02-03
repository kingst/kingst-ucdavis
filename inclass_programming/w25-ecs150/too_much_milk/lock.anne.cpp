


lock()            // 
if(noMilk && noNote) {
  noNote = false; // 
  unlock();       // 
  buyMilk();      // 
  noMilk = false; // 
  noNote = true;  // 
} else {
  unlock();
}
