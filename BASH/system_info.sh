#!/bin/bash

#echo "if [ -f /root/system_info.sh ]; then /bin/bash /root/system_info.sh ; fi" >> /root/.bashrc

OSNAME=`uname`
ARCH=`uname -m`
panel="no panel"
if  [ "$OSNAME" == "Linux" ]; then
        if  [ -r "/etc/redhat-release" ]; then OSVER=`cat /etc/redhat-release| cut -d " " -f 1`; OSVERNUM=`egrep -o '[0-9]+\.[0-9]+' /etc/redhat-release` ;  fi
        if [[ $(cat /etc/*release|grep -i "NAME="|grep -i debian) ]]; then OSVER="Debian" ; OSVERNUM=$(cat /etc/debian_version) ; fi
        if [[ $(cat /etc/*release|grep -i "NAME="|grep -i ubuntu) ]]; then OSVER="Ubuntu" ; OSVERNUM=`cat /etc/issue.net|awk '{print $2,$3}'` ; fi
fi
if [ -d /usr/local/vesta ]; then 	panel="VestaCP"; fi
if [ -d /usr/local/mgr5 ]; then 	panel="ISPmanager"; fi
if [ -d /usr/local/directadmin ]; then 	panel="DirectAdmin"; fi
if [ -d /etc/webmin ]; then 	panel="Webmin+Virtualmin"; fi
IP=`ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1`
MEMTOTAL=`cat /proc/meminfo | grep "MemTotal:" | awk '{print $2}'`
MEMFREE=`cat /proc/meminfo | grep "MemFree:" | awk '{print $2}'`
let memtotalMB=$MEMTOTAL/1024
let memfreeMB=$MEMFREE/1024
clear
echo -e "
\e[32;3mSystem:\e[0m\e[37;3m$OSVER $OSVERNUM $ARCH $OSNAME \t\e[0m \e[32;3mKernel:\e[0m\e[37;3m`uname -r` \t\e[0m \e[32;3mPanel:\e[0m\e[37;3m$panel\e[0m
\e[32;3mCPU:\e[0m\e[37;3m`grep "model name" /proc/cpuinfo | head -n1 | cut -f 2 -d ":"| sed 's/ \{1,\}/ /g'` \t\e[0m \e[32;3mCPU_count:\e[0m\e[37;3m`cat /proc/cpuinfo | grep 'physical id' | sort | uniq | wc -l`\e[0m \t \e[32;3mCores_per_1_CPU:\e[0m\e[37;3m`cat /proc/cpuinfo|grep 'cpu cores' | sed 's|.* ||'|head -n1`\e[0m
\e[32;3mLA:\e[0m\e[37;3m`cat /proc/loadavg | awk '{print $1"/"$2"/"$3}'`\e[0m
\e[32;3mRAM:\e[0m\e[37;3m"$memfreeMB"Mb/"$memtotalMB"Mb\e[0m \t \e[32;3mSWAP:\e[0m\e[37;3m`cat /proc/swaps | grep "^/"|awk '{print $4"Mb/"$3/1024"Mb "$1}'`\e[0m \t \e[32;3mDISK:\e[0m\e[37;3m`df -hT | egrep "G|T" | awk '{print $5"/"$3" "$7}'`\e[0m
\e[32;3mWHO:\e[0m
\e[37;3m`who | awk '{print $1" "$5" "$4" "$3}'`\e[0m
"
