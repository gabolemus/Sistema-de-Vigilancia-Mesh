#pragma once

#include <string>

using namespace std;

class MeshNode
{
private:
  int port;
  string group;
  int sockfd;
  string message;

public:
  /** @brief Inicializar los atributos de la clase */
  MeshNode();

  /** @brief Ejecutar script para configurar el nodo en la red mesh */
  void startMeshNode();

  /** @brief Configurar dirección IPv6 y puerto del socket */
  void configureSocket();

  /** @brief Enviar mensaje a todos los nodos en la red mesh */
  void sendMessage();

  /** @brief Recibir mensaje de todos los nodos en la red mesh */
  void receiveMessage();

  /** @brief Ejecutar script para detener el nodo en la red mesh */
  void stopMeshNode();

  /** @brief Método destructor */
  ~MeshNode();
};
