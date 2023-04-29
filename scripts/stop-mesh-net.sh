#!/bin/bash

# Detener el script si ocurre un error
set -e

# Obtener las variables de entorno locales
# Si no está definida la variable $iface o no existe el archivo .env.local, salir
if [ -f .env.local ]; then
  source .env.local
else
  echo "No existe el archivo .env.local. Por favor, cree uno a partir del archivo .env.example"
  exit 1
fi

if [ -z "$iface" ]; then
  echo "La variable \$iface no está definida. Por favor, especifíquela en el archivo .env.local"
  exit 1
fi

# Detener la red mesh
# ip link set "$iface" down
ip link set mesh0 down
iw mesh0 del
iw "$iface" set type managed
ip link set "$iface" up

# Restaurar los servicios de red WPA
systemctl restart NetworkManager
systemctl unmask wpa_supplicant
systemctl start wpa_supplicant
