#include <iostream>
#include <fstream>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>
#include<string.h>
using namespace std;
int main() {
	
	int fd;
	cout <<"Hello 1"<< endl;
	fd=open("myfile.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
	cout<<"Hello 2";
	cout.flush();
	dup2(fd,STDOUT_FILENO);
	close(fd);
	cout<<"\nhello3" << endl;
	return 0;
}
