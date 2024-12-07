#define UCD      0
#define SACSTATE 1

mutex_t lock;
cond_t bathroomFree;
int currentTeam = UCD;
int bathroomCount = 0;

void goToRestroom(int myTeam, string studentId) {
  lock.lock();
  while (bathroomCount > 0 && currentTeam != myTeam) {
    wait(lock, bathroomFree);
  }
  currentTeam = myTeam;
  bathroomCount += 1;
  
  lock.unlock();
  toilet.use();
  lock.lock();

  bathroomCount -= 1;
  if (bathroomCount == 0) {
    broadcast(bathroomFree);
  }

  lock.unlock();
}

////////////////////////////////////

queue urlData;

void makeHttpRequest(string requesterID, string url) {
  urlData.add(requesterID, url);
}

void processAllHttpRequests() {
  while (urlData.size() != 0) {
    <requesterID, url> = urlData.remove();
    // assume that `serviceRequest` is quick
    urlData.serviceRequest();
  }
}

