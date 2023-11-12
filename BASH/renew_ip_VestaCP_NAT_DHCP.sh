#!/bin/bash
#Замена динамическо изменяемого IP серой сети для VestaCP#
#
#нужно указать реальный IP сервера
vps_ip="192.171.231.123"


#
#
sys_ip=`ip a | grep inet | egrep -v "inet6|127.0.0.1" | awk '{print $2}' | cut -d/ -f1`
bad_ip="123.123.123.123"

#проверка, добавлен ли  новый IP серой сети в систему,
for vesta_ip in `v-list-sys-ips | awk '{print $1}' | egrep -v "IP|--"`; do
    if [ "$vesta_ip" == "$sys_ip" ]
        then
            echo vesta_ip IP matched with sys_ip
        else
            bad_ip=$vesta_ip
            if [ "`v-list-sys-ip $sys_ip | grep $sys_ip| awk '{print $2}'`" == "$sys_ip" ]
                then
                    echo sys_ip was added
                else
                    echo add new sys_ip $sys_ip
                    v-add-sys-ip $sys_ip 255.255.255.254
                    v-change-sys-ip-nat $sys_ip $vps_ip
            fi
    fi
done

#Смена IP для доменов на новый
for user in `v-list-users | awk '{print $1}' | egrep -v "USER|----"` ; do
    for domain in  `v-list-web-domains $user | awk '{print $1}' | egrep -v "DOMAIN|------"` ; do
        IP=`v-list-web-domain $user $domain | grep "IP:" | awk '{print $2}'`
        echo "$user  --- $domain   ---  $IP "
        if [ "$IP" == "$sys_ip" ]
            then
                echo Domain IP matched
            else
                echo Domain IP not matched
                v-change-web-domain-ip  $user $domain $sys_ip
        fi
    done
done

#Оновление информации о IP доменов в системе
v-update-sys-ip-counters

#Удаление старого IP
if [ "`v-list-sys-ip $bad_ip | grep $bad_ip | awk '{print $2}'`" == " $bad_ip" ]
    then
        v-delete-sys-ip $bad_ip
    else
        echo bad ip not found
fi
