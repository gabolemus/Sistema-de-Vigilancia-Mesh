# Nombre de la interfaz de red (wlp2s0, wlan0, eth0, etc)
IFACE=wlp2s0

# Detener los servicios de red DHCP y WPA
# Estos servicios interfieren con la configuración de la red
sudo systemctl stop wpa_supplicant
sudo systemctl mask wpa_supplicant

# Configuración de la red mesh ad-hoc
sudo ip link set $IFACE down
sudo iw $IFACE set type ibss
sudo ifconfig $IFACE mtu 1532
sudo iwconfig $IFACE channel 1
sudo ip link set $IFACE up
# TODO: configurar la celda para poder conectarse a una red mesh existente
sudo iw $IFACE ibss join sistemas-inalambricos 2432 HT20 fixed-freq 02:12:34:56:78:9A

# Configuración BATMAN-ADV
sudo modprobe batman-adv
sudo batctl if add $IFACE
sudo ip link set bat0 up
sudo ifconfig bat0
