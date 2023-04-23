#pragma once

#include <string>

using namespace std;

class MeshNode
{
private:
  int port;
  string group;

public:
  /** @brief Inicializar los atributos de la clase */
  MeshNode();

  /** @brief Ejecutar script para configurar el nodo en la red mesh */
  void startMeshNode();

  /** @brief Ejecutar script para detener el nodo en la red mesh */
  void stopMeshNode();
};
