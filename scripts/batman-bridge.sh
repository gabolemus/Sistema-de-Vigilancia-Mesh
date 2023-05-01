#!/bin/bash

# Detener el script si ocurre un error
set -e

# Constantes
channel="1"
ssid="sistemas-inalambricos"
mtu="1532"

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

# Detener los servicios de red WPA
# Estos servicios interfieren con la configuración de la red
systemctl stop wpa_supplicant
systemctl mask wpa_supplicant
systemctl stop NetworkManager

# Eliminar la interfaz de red
iw dev $iface del

# Crear la interfaz de red
iw phy phy0 interface add $iface type ibss

# Configurar MTU
ip link set up mtu $mtu dev $iface

# Deshabilitar el modo de ahorro de energía y la encriptación
# iwconfig $iface power off
iwconfig $iface enc off

# Crear/unirse a la red mesh
iw dev $iface ibss join $ssid 2412 HT20 fixed-freq 02:12:34:56:78:9A

# Agregar la interfaz a la red mesh
batctl if add $iface
ip link set up dev bat0

# Configuración de la dirección IP
ifconfig $iface 192.168.2.2/24
