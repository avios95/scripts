#!/bin/bash
# 
# version 1.0
# Check OS / Location from whois of base ip/ Changes password for root / System info / Info for Client / 
# version 2.0
# Added: Check install whois / Check control panel / Changes password for panel user / Generate panel URL / Print "Control panel" block if panel is installed
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
Dear customer, in this ticket handling issues related only to the preparation of your service.
On other issues and problems yum will open new tickets. This ticket they will not be considered.

We also want to remind you that the refusal of service is received no later than 3 (three) days prior to the beginning of a new period of paid.
To do this you need to open a ticket in the category Cancel

Уважаемый клиент, в этом тикете решаются вопросы, связанные только с подготовкой Вашего сервиса.
С другими вопросами и проблемами открывайте новые тикеты. В этом тикете они рассматриваться не будут.

Также хотим Вам напомнить, что отказ от услуг принимается не позднее 3 (трех) дней до начала нового оплачиваемого периода.
Для этого Вам необходимо оформить запрос через https://amhost.net/hosting/service/cancel/ или открыть тикет в категории Cancel. 

===============================================
"




