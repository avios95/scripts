#!/bin/bash
host_name=`hostname`
resolv_ip=""
phpver=""
for user in `ls -1 /usr/local/directadmin/data/users/`; do
    for domain in `cat /usr/local/directadmin/data/users/$user/domains.list`; do
        domain_ip=`cat /usr/local/directadmin/data/users/$user/domains/$domain.ip_list`

            resolv_ip=`dig @1.1.1.1 +short $domain`
            if [ "$domain_ip" != "$resolv_ip"  ] ; then
              echo "domain_ip \!= resolv_ip" >/dev/null
            else
                echo "<?php phpinfo(); ?>" > /home/$user/domains/$domain/public_html/check_php_version.php
                if ! [ -d /home/$user/domains/$domain/private_html/ ]; then
                    echo "none" > /dev/null
                else
                    echo "<?php phpinfo(); ?>" > /home/$user/domains/$domain/private_html/check_php_version.php
                fi
                phpver=`curl -IL $domain/check_php_version.php 2>/dev/null | grep "X-Powered-By" | sed "s#X-Powered-By: PHP\/##g"| uniq`
                echo "$host_name |  $domain_ip | $user | $domain | $phpver" >> /root/da_check.info
            fi
    done
done
