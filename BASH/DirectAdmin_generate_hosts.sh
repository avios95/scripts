#!/bin/bash
#Генерация hosts на шареде Directadmin


for user in `ls -1 /usr/local/directadmin/data/users/ `;do
    echo "#========== $user ========== ";
    for domain in `cat /usr/local/directadmin/data/users/$user/domains.list` ; do
        echo `cat /usr/local/directadmin/data/users/$user/user_ip.list`" www.$domain $domain"
    done
done | nc termbin.com 9999
