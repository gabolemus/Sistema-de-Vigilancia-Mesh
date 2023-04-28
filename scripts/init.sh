# Activate batman-adv
sudo modprobe batman-adv

# Disable and configure wlp2s0
sudo ip link set wlp2s0 down
sudo ifconfig wlp2s0 mtu 1532
sudo iwconfig wlp2s0 mode ad-hoc
sudo iwconfig wlp2s0 essid sistemas-inalambricos
sudo iwconfig wlp2s0 ap any
sudo iwconfig wlp2s0 channel 8
sleep 1s
sudo ip link set wlp2s0 up
sleep 1s
sudo batctl if add wlp2s0
sleep 1s
sudo ifconfig bat0 up
sleep 5s

# Use different IPv4 addresses for each device
# This is the only change necessary to the script for
# different devices. Make sure to indicate the number
# of bits used for the mask.
sudo ifconfig bat0 172.27.0.1/16

