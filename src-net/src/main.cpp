#include <arpa/inet.h>
#include <csignal>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#include "../include/MeshNode.hpp"

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

  // Iniciar el nodo en la red mesh
  meshNode = MeshNode();
  meshNode.startMeshNode();

  // Esperar hasta que se presione Ctrl+C
  while (true) {
    printf("Presione Ctrl+C para detener la red mesh.\n");
    sleep(5);
  }

  return 0;
}
