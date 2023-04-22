# Interface name
IFACE=wlp2s0

# Stop the ad-hoc network
sudo ip link set $IFACE down
sudo iw $IFACE set type managed
sudo ip link set $IFACE up

# Restore the original configuration
sudo systemctl unmask wpa_supplicant
sudo systemctl start wpa_supplicant
