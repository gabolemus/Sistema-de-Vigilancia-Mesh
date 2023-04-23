#include <csignal>
#include <string>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <iostream>

#include "../include/MeshNode.hpp"

using namespace std;

// Constantes globales
MeshNode meshNode;

void signalInterruptionHandler(int signum) {
  // Imprimir caracter de borrado de línea
  printf("\n\033[1A\033[2K");

  // Detener el nodo en la red mesh
  meshNode.stopMeshNode();

  exit(signum == SIGINT ? 0 : 1);
}

int main() {
  // Registrar el manejador de la señal SIGINT para detener la red mesh
  signal(SIGINT, signalInterruptionHandler);

  int port = 8080;
  string group = "ff02::1";
  string message = "Hola, desde el nodo en la red mesh!";
  int sockfd = socket(AF_INET6, SOCK_DGRAM, 0); // Crear el socket UDP IPv6
  struct sockaddr_in6 addr;

  memset(&addr, 0, sizeof(addr));
  addr.sin6_family = AF_INET6;
  addr.sin6_port = htons(port);
  inet_pton(AF_INET6, group.c_str(), &addr.sin6_addr);

  // Enviar mensaje a todos los nodos en la red mesh
  printf("Enviando mensaje a todos los nodos en la red mesh...\n");
  sendto(sockfd, message.c_str(), message.length(), 0, (struct sockaddr *)&addr, sizeof(addr));
  printf("Mensaje enviado.\n");

  // Esperar hasta recibir un mensaje de otro nodo en la red mesh
  char buffer[1024];
  struct sockaddr_in6 src_addr;
  socklen_t src_addr_len = sizeof(src_addr);
  recvfrom(sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&src_addr, &src_addr_len);

  printf("Mensaje recibido: %s", buffer);

  return 0;
}
