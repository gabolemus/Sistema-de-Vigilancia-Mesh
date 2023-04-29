#!/bin/bash

set -e

channel="1"
ssid="sistemas-inalambricos"
mtu="1532"

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

# Ensure that the batman-adv kernel module is loaded
modprobe batman-adv
echo "batman-adv" | tee /etc/modules

# Stop the DHCP process from trying to manage the interface
echo "denyinterfaces $iface" | tee -a /etc/dhcpcd.conf

# Batman-adv interface to use
batctl if add "$iface"
bat0 mtu 1468

# Tell batman-adv this is a gateway client
batctl gw_mode client

# Interface configuration
ifconfig "$iface" down
iw "$iface" set type ibss
# ifconfig "$iface" mtu "$mtu"
iwconfig "$iface" channel "$channel"
iw "$iface" ibss join "$ssid" 2432 HT20 fixed-freq 02:12:34:56:78:9A

# Activate the batman-adv interfaces
ifconfig "$iface" up
ifconfig bat0 up
