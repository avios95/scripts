#!/bin/bash

host_name=`hostname`
OSNAME=""
OSVER=""
OSVERNUM=""
OSNAME=`uname`
ARCH=`uname -m`

#---------OS Linux-------------
if  [ "$OSNAME" == "Linux" ]; then
    echo $OSNAME
#------CentOS)---------------
    if  [ -r "/etc/redhat-release" ]; then
        OSVER=`cat /etc/redhat-release| cut -d " " -f 1`
        OSVERNUM=`egrep -o '[0-9]+\.[0-9]+' /etc/redhat-release`
    fi
#--------Debian--------------------
        if [[ $(cat /etc/*release|grep -i "NAME="|grep -i debian) ]]; then
                OSVER="debian"
                OSVERNUM=$(cat /etc/debian_version)
        fi
#------Ubuntu-------------------------------
        if [[ $(cat /etc/*release|grep -i "NAME="|grep -i ubuntu) ]]; then
                OSVER="Ubuntu"
                OSVERNUM=`cat /etc/issue.net|awk '{print $2,$3}'`
        fi
fi


if [ -d /etc/webmin ]; then
    PANEL=Virtualmin-Webmin ;echo $host_name / $PANEL / $OSVER $OSVERNUM $ARCH / `ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1|xargs -n 6`

    resolv_ip="1"
    for domain in `virtualmin list-domains | egrep -v "^---|^Domain|tld" | awk '{print $1}'`; do
        user=`virtualmin list-domains --domain $domain| egrep -v "^---|^Domain" | awk '{print $2}'`
        for IP in `virtualmin list-shared-addresses | egrep -v "^--|Address"|awk '{print $1}'`; do
            resolv_ip=`dig A @1.1.1.1 +short $domain`"."
            if [ "$IP." != "$resolv_ip"  ] ; then
              continue
              #echo "$IP | $user | $domain | (resolv ip: $resolv_ip)"
            else
                echo "$IP | $user | $domain "
            fi
        done
    done



elif [ -d /usr/local/vesta ]; then
    PANEL=VestaPanel ;echo $host_name / $PANEL / $OSVER $OSVERNUM $ARCH / `ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1|xargs -n 6`
    resolv_ip="1"
    for user in `v-list-users | awk '{print $1}' | egrep -v "USER|----"` ; do
        for domain in  `v-list-web-domains $user | awk '{print $1}' | egrep -v "DOMAIN|------"` ; do
            IP=`v-list-web-domain $user $domain | grep "IP:" | awk '{print $2}'`
            resolv_ip=`dig A @1.1.1.1 +short $domain`
            if [ "$IP" != "$resolv_ip"  ] ; then
              echo "$IP | $user | $domain | (resolv ip: $resolv_ip)"
            else
                echo "$IP | $user | $domain "
            fi
        done
    done


elif [ -d /usr/local/directadmin ]; then
    PANEL=DirectAdmin ;echo $host_name  / $PANEL / $OSVER $OSVERNUM $ARCH / `ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1|xargs -n 6`

    resolv_ip="1"
    for user in `ls -1 /usr/local/directadmin/data/users/`; do
        for domain in `cat /usr/local/directadmin/data/users/$user/domains.list`; do
            domain_ip=`cat /usr/local/directadmin/data/users/$user/user_ip.list`
                resolv_ip=`dig A @1.1.1.1 +short $domain`
                if [ "$domain_ip" != "$resolv_ip"  ] ; then
                  echo "$domain_ip | $user | $domain | (resolv ip: $resolv_ip)"
                else
                    echo "$domain_ip | $user | $domain "
                fi
        done
    done
elif [ -d /usr/local/mgr5 ]; then
    PANEL=ISPmanager ;echo $host_name / $PANEL / $OSVER $OSVERNUM $ARCH / `ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1|xargs -n 6`

else
    PANEL=none ;echo $host_name / $PANEL / $OSVER $OSVERNUM $ARCH / `ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1|xargs -n 6`

fi
