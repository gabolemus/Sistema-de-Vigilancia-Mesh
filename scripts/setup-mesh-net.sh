#!/bin/bash

# Detener el script si ocurre un error
set -e

# Constantes
iface="wlp2s0" # Nombre de la interfaz de red (wlp2s0, wlan0, eth0, etc)
channel="1"
ssid="sistemas-inalambricos"
mtu="1532"

# Detener los servicios de red WPA
# Estos servicios interfieren con la configuración de la red
sudo systemctl stop wpa_supplicant
sudo systemctl mask wpa_supplicant

# Configuración de la red mesh ad-hoc
sudo ip link set "$iface" down
sudo iw "$iface" set type ibss
sudo ifconfig "$iface" mtu "$mtu"
sudo iwconfig "$iface" channel "$channel"
sudo ip link set "$iface" up
# TODO: configurar la celda para poder conectarse a una red mesh existente
sudo iw "$iface" ibss join "$ssid" 2432 HT20 fixed-freq 02:12:34:56:78:9A

# Configuración BATMAN-ADV
sudo modprobe batman-adv
sudo batctl if add "$iface"
sudo ip link set bat0 up
sudo ifconfig bat0 192.168.1.1 netmask 255.255.255.0

# Configuración de direcciones IP estáticas
sudo ifconfig "$iface" 192.168.1.2 netmask 255.255.255.0
