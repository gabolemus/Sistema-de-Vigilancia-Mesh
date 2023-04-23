#include <iostream>

#include "../include/MeshNode.hpp"

MeshNode::MeshNode() {
  // Inicializar las constantes globales
  this->port = 8080;
  this->group = "ff02::1";
}

void MeshNode::startMeshNode() {
  // Ejecutar el script de configuración de la red mesh
  printf("Estableciendo red mesh...\n\n");
  system("./scripts/setup-mesh-net.sh");
  printf("Red mesh establecida.\n\n");
}

void MeshNode::stopMeshNode() {
  // Ejecutar el script para detener la red mesh
  printf("\nDeteniendo red mesh...\n");
  system("./scripts/stop-mesh-net.sh");
  printf("\nRed mesh detenida.\n");
}
