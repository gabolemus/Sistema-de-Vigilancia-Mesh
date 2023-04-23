#!/bin/bash

# Detener el script si ocurre un error
set -e

# Constantes
iface="wlp2s0" # Nombre de la interfaz de red (wlp2s0, wlan0, eth0, etc)

# Detener la red mesh
sudo ip link set "$iface" down
sudo iw "$iface" set type managed
sudo ip link set "$iface" up

# Restaurar los servicios de red WPA
sudo systemctl unmask wpa_supplicant
sudo systemctl start wpa_supplicant
