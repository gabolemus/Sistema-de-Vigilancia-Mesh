#!/bin/bash

# Nombre de la interfaz de red (wlp2s0, wlan0, eth0, etc)
IFACE=wlp2s0

# Detener la red mesh
sudo ip link set $IFACE down
sudo iw $IFACE set type managed
sudo ip link set $IFACE up

# Restaurar los servicios de red DHCP y WPA
sudo systemctl unmask wpa_supplicant
sudo systemctl start wpa_supplicant
