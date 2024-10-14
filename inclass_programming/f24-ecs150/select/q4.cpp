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
	fd=open("myfile.txt", O_WRONLY);
	cout<<"Hello 2";
	dup2(fd,STDOUT_FILENO);
	close(fd);
	cout<<"\nhello3" << endl;
	return 0;
}
