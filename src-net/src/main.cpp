#include <csignal>
#include <iostream>
#include <stdio.h>
#include <stdlib.h>

void signalInterruptionHandler(int signum) {
  // Ejecutar el script para detener la red mesh
  std::cout << "Deteniendo red mesh..." << std::endl;
  system("./scripts/stop-mesh-net.sh");
  std::cout << "Red mesh terminada." << std::endl;

  exit(signum == SIGINT ? 0 : 1);
}

int main() {
  // Registrar el manejador de señales
  signal(SIGINT, signalInterruptionHandler);

  // Ejecutar el script de configuración de la red mesh
  std::cout << "Estableciendo red mesh..." << std::endl;
  system("./scripts/setup-mesh-net.sh");
  std::cout << "Red mesh establecida." << std::endl;

  // Esperar hasta que se presione Ctrl+C
  while (true) {
    std::cout << "Presione Ctrl+C cuando desee detener la red mesh." << std::endl;
    sleep(5);
  }

  return 0;
}
