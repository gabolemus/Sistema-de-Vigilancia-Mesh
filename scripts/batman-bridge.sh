#!/bin/sh

# This script will automatically join a mesh network.
# Modified script from: 
# https://www.irif.univ-paris-diderot.fr/~jch/software/files/wifi-autoconf.sh

essid="sistemas-inalambricos"
channel=1
ipaddress=192.168.1.1

die() {
	echo "$@" >&2
	exit 1
}

findcmd() {
	type "$1" > /dev/null || \
	    die "Couldn't find $1, please install ${2:-it} or fix your path."
}

if [ "$(whoami)" != root ]; then
	die "Sorry, you need to be root."
fi

usage="Usage: $0 [-d debuglevel] [-r interface] interface ip-address/cidr"
debuglevel=0
routeinterface=

while getopts "Nd:r:" name
do
	case $name in
		d) debuglevel="$OPTARG";;
		r) routeinterface="$OPTARG";;
		?) die "$usage"
	esac
done

shift $(($OPTIND - 1))

[ $# -lt 2 ] && die "$usage"

findcmd iwconfig "wireless-tools"
findcmd babeld
findcmd generate-ipv6-address

(ip -6 addr show dev lo | grep -q 'inet6') || \
	die "No IPv6 address on lo, please modprobe ipv6"

interface="$1"

# order is important for mac80211-based drivers

ifconfig "$interface" down || die "Couldn't configure interface"
iwconfig "$interface" mode ad-hoc || die "Couldn't configure interface"
ifconfig "$interface" up || die "Couldn't configure interface"
iwconfig "$interface" essid "$essid" channel $channel || \
	die "Couldn't configure interface"

ip link set up dev "$interface" || die "Couldn't up interface"

shift

ipaddress="$1"

ip addr add $ipaddress dev $interface || die "Couldn't set IPv4 address"
ip -6 addr add $(generate-ipv6-address fe80::) dev $interface || die "Couldn't set IPv6(loopback) address"

if [ -n "$routeinterface" ]
then
	echo "setting up routing for interface $routeinterface"

	iptables -t nat -A POSTROUTING -o $routeinterface -j MASQUERADE
	iptables -A FORWARD -i $routeinterface -o $interface -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -i $interface -o $routeinterface -j ACCEPT

	gateway=$(route -n | grep eth0 | awk '{print $2}' | head -1)
	ip route add 0.0.0.0/0 via $gateway dev $routeinterface proto static
fi

terminate() {
	echo -n 'Killing babel...'
	[ -e /var/run/babeld.pid ] && kill "$(cat /var/run/babeld.pid)"
	echo 'done.'
	ip addr flush dev $interface
	trap - EXIT
	exit 0
}

trap terminate INT QUIT TERM EXIT

# allow time for the link layer to associate
sleep 1

if [ -n "$routeinterface" ]
then
	babeld ${debuglevel:+-d} $debuglevel -z 3 -C 'redistribute metric 128' $interface &
else
	babeld ${debuglevel:+-d} $debuglevel -z 3 $interface &
fi

echo "Babeld running on $interface, press ^C to terminate."
echo "IP-Address is: $ipaddress"

while :; do sleep 3600; done
