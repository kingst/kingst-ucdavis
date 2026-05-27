#include <arpa/inet.h>
#include <netinet/in.h>
#include <pthread.h>
#include <sys/socket.h>
#include <unistd.h>

#include <cstring>
#include <iostream>
#include <string>

static const int kPort = 8080;
static const int kBacklog = 10;

void *client_thread_main(void *arg) {
    int client_fd = *static_cast<int *>(arg);
    delete static_cast<int *>(arg);

    char request[5];
    std::memset(request, 0, sizeof(request));

    recv(client_fd, request, 4, 0);
    std::cout << "Server received: " << request << std::endl;

    if (std::string(request) == "ping") {
        send(client_fd, "pong", 4, 0);
    }

    close(client_fd);
    return NULL;
}

int run_server() {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    
    sockaddr_in address;
    std::memset(&address, 0, sizeof(address));
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_ANY);
    address.sin_port = htons(kPort);

    bind(server_fd, reinterpret_cast<sockaddr *>(&address), sizeof(address));
    listen(server_fd, kBacklog);

    std::cout << "Server listening on 127.0.0.1:" << kPort << std::endl;

    while (true) {
        sockaddr_in client_address;
        std::memset(&client_address, 0, sizeof(client_address));
        socklen_t client_length = sizeof(client_address);
        int client_fd = accept(
            server_fd,
            reinterpret_cast<sockaddr *>(&client_address),
            &client_length);

        pthread_t thread;
        int *thread_arg = new int(client_fd);
        pthread_create(&thread, NULL, client_thread_main, thread_arg);
        pthread_detach(thread);
    }

    close(server_fd);
    return 0;
}

int run_client(const char *server_ip) {
    int client_fd = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in server_address;
    std::memset(&server_address, 0, sizeof(server_address));
    server_address.sin_family = AF_INET;
    server_address.sin_port = htons(kPort);
    inet_pton(AF_INET, server_ip, &server_address.sin_addr);

    connect(client_fd, reinterpret_cast<sockaddr *>(&server_address), sizeof(server_address));
    send(client_fd, "ping", 4, 0);

    char response[5];
    std::memset(response, 0, sizeof(response));
    recv(client_fd, response, 4, 0);

    std::cout << "Client received: " << response << std::endl;
    close(client_fd);
    return 0;
}

int main(int argc, char *argv[]) {
    if (argc < 2 || argc > 3) {
        std::cerr << "Usage: " << argv[0] << " server" << std::endl;
        std::cerr << "       " << argv[0] << " client [server_ip]" << std::endl;
        return 1;
    }

    std::string mode = argv[1];
    if (mode == "server") {
        return run_server();
    }
    if (mode == "client") {
        const char *server_ip = "127.0.0.1";
        if (argc == 3) {
            server_ip = argv[2];
        }
        return run_client(server_ip);
    }

    std::cerr << "Unknown mode: " << mode << std::endl;
    return 1;
}
