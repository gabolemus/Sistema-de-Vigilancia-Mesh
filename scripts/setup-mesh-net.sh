# Interface name
IFACE=wlp2s0

# Stop DHCP and WPA services
sudo systemctl stop wpa_supplicant
sudo systemctl mask wpa_supplicant

# Setup the ad-hoc network
sudo ip link set $IFACE down
sudo iw $IFACE set type ibss
sudo ifconfig $IFACE mtu 1532
sudo iwconfig $IFACE channel 1
sudo ip link set $IFACE up
sudo iw $IFACE ibss join "sistemas-inalambricos" 2432 fixed-freq 02:11:22:33:44:55 cell 1

# BATMAN-ADV configuration
sudo modprobe batman-adv
sudo batctl if add $IFACE
sudo ip link set bat0 up
sudo ifconfig bat0
