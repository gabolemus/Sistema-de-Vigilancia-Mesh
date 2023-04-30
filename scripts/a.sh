#!/bin/bash

ifconfig wlp2s0 mtu 1528
ifconfig wlp2s0 down
iwconfig wlp2s0 mode ad-hoc essid my-mesh-network ap 02:12:34:56:78:90 channel 1
batctl if add wlp2s0
ifconfig wlp2s0 up
ifconfig bat0 up
ifconfig bat0 192.168.2.1
