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

# Configuración de la red mesh ad-hoc
ip link set "$iface" down
iw "$iface" set type ibss
ifconfig "$iface" mtu "$mtu"
iwconfig "$iface" channel "$channel"
ip link set "$iface" up
iw "$iface" ibss join "$ssid" 2432 HT20 fixed-freq 02:12:34:56:78:9A

# Configuración BATMAN-ADV
modprobe batman-adv
batctl if add "$iface"
ip link set bat0 up
ifconfig bat0
