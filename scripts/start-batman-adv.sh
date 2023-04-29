#!/bin/bash

# Detener el script si ocurre un error
set -e

# Constantes
channel="1"
ssid="sistemas-inalambricos"
mtu="1532"

# Obtener las variables de entorno locales
# Si no están definidas las variable $iface, $ether_iface y $node_ip_addr o no existe el archivo .env.local, salir
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

if [ -z "$ether_iface" ]; then
  echo "La variable \$ether_iface no está definida. Por favor, especifíquela en el archivo .env.local"
  exit 1
fi

if [ -z "$node_ip_addr" ]; then
  echo "La variable \$node_ip_addr no está definida. Por favor, especifíquela en el archivo .env.local"
  exit 1
fi

# Detener los servicios de red WPA
# Estos servicios interfieren con la configuración de la red
systemctl stop wpa_supplicant
systemctl mask wpa_supplicant

# Configurar el nodo como un gateway
batctl gw_mode server

# Habilitar el forwarding de paquetes
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o "$ether_iface" -j MASQUERADE
iptables -A FORWARD -i "$ether_iface" -o bat0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i bat0 -o "$ether_iface" -j ACCEPT

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
ifconfig bat0 "$node_ip_addr"/24
