





void enqueue() {
  lock(queueLock);
  ptr = findTailOfQueue();

  // add new element
  ptr->next = new_element;
  new_element->next = NULL;

  if (!waitList.empty()) {
    wake(waitList.pop());
  } 
  unlock(queueLock);
}
