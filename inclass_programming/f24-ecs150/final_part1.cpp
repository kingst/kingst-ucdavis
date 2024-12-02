#define UCD      0
#define SACSTATE 1


void goToRestroom(int myTeam, string studentId) {
  toilet.use()
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

