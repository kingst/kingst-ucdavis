element_t dequeue() {
  lock(queueLock);
  element = NULL;
  if(head->next == NULL) {
    waitList.add(getThreadId());
    unlock(queueLock);













    sleep();
    lock(queueLock);
  }    
  element = head->next;
  head->next = head->next->next;
  
  unlock(queueLock);
  return element;
}
