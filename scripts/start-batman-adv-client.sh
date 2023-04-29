#!/bin/bash

# Detener el script si ocurre un error
set -e

# Constantes
channel="1"
ssid="sistemas-inalambricos"
mtu="1468"

# Obtener las variables de entorno locales
# Terminar la ejeucicón si no está definida la variable $iface o no existe el archivo .env.local
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

# Detener el servicio de red WPA
systemctl stop wpa_supplicant
systemctl mask wpa_supplicant

# Asegurarse de que el módulo del kernel batman-adv está cargado
modprobe batman-adv
echo "batman-adv" | tee --append /etc/modules

# Detener el servicio DHCP
echo "denyinterfaces $iface" | tee --append /etc/dhcpcd.conf

# Configuración de la interfaz que batman-adv usará
batctl if add "$iface"
ifconfig bat0 mtu "$mtu"

# Indicarle a batman-adv que este es un cliente gateway
batctl gw_mode client

# Configuración de la red mesh ad-hoc
ip link set "$iface" down
iw "$iface" set type ibss
ifconfig "$iface" mtu "$mtu"
iwconfig "$iface" channel "$channel"
ip link set "$iface" up
iw "$iface" ibss join "$ssid" 2432 HT40+ fixed-freq 02:12:34:56:78:9A

# Establecer las interfaces
ifconfig "$iface" up
ifconfig bat0 up
