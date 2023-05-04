#!/bin/bash

# Detener el script si ocurre un error
set -e

# Constantes
channel="9"
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

ip link set $iface down #e.g. $iface = wlan0
iw $iface set type ibss
ifconfig $iface mtu 1532 # This is necessary for batman-adv
iwconfig $iface channel $channel
ip link set $iface up
iw $iface ibss join $ssid 2452 # e.g. <ssid> = my-mesh-network

modprobe batman-adv
batctl if add $iface # e.g. $iface = wlan0
ip link set up dev $iface
ip link set up dev bat0
ifconfig bat0 172.27.0.1/16 # Can be any other valid IP.
