element_t dequeue() {
  lock(queueLock);
  element = NULL;
  if(head->next == NULL) {
    unlock(queueLock);
    waitList.add(getThreadId());
    sleep();
    lock(queueLock);
  }    
  element = head->next;
  head->next = head->next->next;
  
  unlock(queueLock);
  return element;
}
