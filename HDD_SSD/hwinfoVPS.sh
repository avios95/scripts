#!/bin/bash
#Author: 	avios
#Github:
#Example:
#Info:		Script to get VPS information and get VPS profile
#
#=================Variables====================
OSNAME=""
OSVER=""
OSVERNUM=""
NEWPASS=""
IP=""
LOCATION=""
meminfo=""
panel="no panel"
port=""
protocol=""
userpanel=""
passpanel=""


NEWPASS=`date +%s | sha512sum | base64 | head -c 12`
IP=`ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1`
MEMINFO=`head -n1 /proc/meminfo | awk '{print $2}'`
let memtotalGB=$MEMINFO/1024/1024
let memtotalMB=$MEMINFO/1024
let memtotalKB=$MEMINFO
#==============================================

#=================Check OS=====================
OSNAME=`uname`
ARCH=`uname -m`

if  [ "$OSNAME" == "Linux" ]; then
	if  [ -r "/etc/redhat-release" ]; then
			OSVER=`cat /etc/redhat-release| cut -d " " -f 1`
			OSVERNUM=`egrep -o '[0-9]+\.[0-9]+' /etc/redhat-release`
			if ! which whois > /dev/null; then
				yum install whois -y
			fi
	fi
	if [[ $(cat /etc/*release|grep -i "NAME="|grep -i debian) ]]; then
			OSVER="Debian"
			OSVERNUM=$(cat /etc/debian_version)
			if ! which whois > /dev/null; then
				apt-get install whois -y
			fi

	fi
	if [[ $(cat /etc/*release|grep -i "NAME="|grep -i ubuntu) ]]; then
			OSVER="Ubuntu"
			OSVERNUM=`cat /etc/issue.net|awk '{print $2,$3}'`
			if ! which whois > /dev/null; then
				apt-get install whois -y
			fi
	fi
fi
#==============================================
LOCATION=`whois $IP  | grep country: | awk '{print $2}'`

#=============Check control panel==============
if [ -d /usr/local/vesta ]; then
	panel="VestaCP"
	port=":8083"
	protocol="
#Control Panel
https://"
	userpanel=`v-list-users | grep default |  awk '{print $1}'`
	passpanel=" / $NEWPASS
"
	IPpanel="$IP"
fi
if [ -d /usr/local/mgr5 ]; then
	panel="ISPmanager"
	port=":1500"
	protocol="
#Control Panel
https://"
	userpanel="root"
	passpanel=" / $NEWPASS
"
	IPpanel="$IP"

fi
if [ -d /usr/local/directadmin ]; then
	panel="DirectAdmin"
	port=":2222"
	protocol="
#Control Panel
http://"
	userpanel="admin"
	passpanel=" / $NEWPASS
"
	IPpanel="$IP"
fi
if [ -d /etc/webmin ]; then
	panel="Webmin+Virtualmin"
	port=":10000"
	protocol="
#Control Panel
https://"
	userpanel="admin"
	passpanel=" / $NEWPASS
"
	IPpanel="$IP"
fi
#==============================================

#==============Change password================
passwd <<EOF
$NEWPASS
$NEWPASS
EOF

passwd $userpanel <<EOF
$NEWPASS
$NEWPASS
EOF

#==============================================

clear

echo "
=================System Info===================
CPU:`grep "model name" /proc/cpuinfo | head -n1 | cut -f 2 -d ":"| sed 's/ \{1,\}/ /g'`
CPU count: `cat /proc/cpuinfo | grep 'physical id' | sort | uniq | wc -l`
Cores per 1 CPU: `cat /proc/cpuinfo|grep 'cpu cores' | sed 's|.* ||'|head -n1`
RAM: "$memtotalKB"Kb / "$memtotalMB"Mb / ~"$memtotalGB"Gb
Disc count: `fdisk -l 2>/dev/null|egrep "* /dev/[^bmr]"|wc -l`
`fdisk -l 2>/dev/null| egrep "* /dev/[^bmr]"|awk '{print $1,$2,$3,$4}'`
=================Client Info===================
Your VPS is ready! / Ваш VPS готов!

VPS package:    / $LOCATION
SystemID: `hostname`
OS: $OSVER $OSVERNUM $ARCH
Extra space:
Control Panel: $panel
Base IP: $IP

#SSH
root / $NEWPASS
$protocol$IPpanel$port
$userpanel$passpanel

===============================================
"
