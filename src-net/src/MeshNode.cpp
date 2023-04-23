#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <iostream>

#include "../include/MeshNode.hpp"

struct sockaddr_in6 addr;

MeshNode::MeshNode() {
  // Inicializar las constantes globales
  this->port = 8080;
  this->group = "ff02::1";
  this->message = "Hola, desde el nodo en la red mesh!";
  this->sockfd = socket(AF_INET6, SOCK_DGRAM, 0); // Crear el socket UDP IPv6

  // Configurar dirección IPv6 y puerto del socket
  this->configureSocket();
}

void MeshNode::startMeshNode() {
  // Ejecutar el script de configuración de la red mesh
  printf("Estableciendo red mesh...\n\n");
  system("./scripts/setup-mesh-net.sh");
  printf("Red mesh establecida.\n\n");
  printf("Presione Ctrl+C para detener la red mesh.\n");
}

void MeshNode::configureSocket() {
  memset(&addr, 0, sizeof(addr));
  addr.sin6_family = AF_INET6;
  addr.sin6_port = htons(this->port);
  inet_pton(AF_INET6, this->group.c_str(), &addr.sin6_addr);
}

void MeshNode::sendMessage() {
  // Enviar mensaje a todos los nodos en la red mesh
  printf("Enviando mensaje a todos los nodos en la red mesh...\n");
  sendto(this->sockfd, this->message.c_str(), this->message.length(), 0, (struct sockaddr *)&addr, sizeof(addr));
  printf("Mensaje enviado.\n");
}

void MeshNode::receiveMessage() {
  char buffer[1024];
  struct sockaddr_in6 src_addr;
  socklen_t src_addr_len = sizeof(src_addr);
  recvfrom(this->sockfd, buffer, sizeof(buffer), 0, (struct sockaddr *)&src_addr, &src_addr_len);

  printf("Mensaje recibido: %s", buffer);
}

void MeshNode::stopMeshNode() {
  // Ejecutar el script para detener la red mesh
  printf("\nDeteniendo red mesh...\n");
  system("./scripts/stop-mesh-net.sh");
  printf("\nRed mesh detenida.\n");
}

MeshNode::~MeshNode() {
  // Cerrar el socket
  close(this->sockfd);
}
