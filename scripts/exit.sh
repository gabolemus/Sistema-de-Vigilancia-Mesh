# Disable batman-adv
sudo ifconfig bat0 down
sudo batctl if del wlp2s0
sudo ip link set wlp2s0 down
sudo ip link set wlp2s0 up
# sudo ifconfig wlp2s0 mtu 1500
# sudo iwconfig wlp2s0 mode managed
# sudo iwconfig wlp2s0 essid sistemas-inalambricos
# sudo iwconfig wlp2s0 ap any
# sudo iwconfig wlp2s0 channel 8
sleep 1s
sudo ip link set wlp2s0 up
sleep 1s
sudo systemctl restart wpa_supplicant
sleep 1s
sudo systemctl restart NetworkManager
sleep 1s
