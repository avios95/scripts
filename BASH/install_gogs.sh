#!/bin/bash

if [ -n "$1" ]
then

    domain=$1
    apt update -y
    apt upgrade -y
    apt install mysql-server pwgen git  golang-go nginx -y

    root_pass=`pwgen -s 16 1`
    gogs_pass=`pwgen -s 16 1`

    echo "
    ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_pass';
    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    CREATE USER 'gogs'@'localhost' IDENTIFIED BY '$gogs_pass';
    CREATE DATABASE IF NOT EXISTS gogs CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
    GRANT ALL PRIVILEGES ON gogs.* TO 'gogs'@'localhost';
    FLUSH PRIVILEGES; " > mysql_secure_installation.sql

    mysql < mysql_secure_installation.sql
    rm -f mysql_secure_installation.sql

    cd /opt/
    adduser --disabled-login --gecos 'Gogs' git
    git clone --depth 1 https://github.com/gogs/gogs.git gogs
    cd ./gogs
    go build -o gogs
    mkdir -p ./custom/conf/

    echo "[server]
    DOMAIN = $domain
    HTTP_ADDR = 127.0.0.1
    HTTP_PORT = 3000
    ROOT_URL = http://$domain/git/
    DISABLE_SSH = false
    SSH_PORT = 22
    OFFLINE_MODE = false
     " > ./custom/conf/app.ini



    chown git. ../gogs -R


    echo "[Unit]
    Description=Gogs (Go Git Service)
    After=syslog.target
    After=network.target
    After=nginx.service

    [Service]
    Type=simple
    User=git
    Group=git
    WorkingDirectory=/opt/gogs
    ExecStart=/opt/gogs/gogs web
    Restart=always
    Environment=USER=git HOME=/opt/gogs

    [Install]
    WantedBy=multi-user.target" > /etc/systemd/system/gogs.service



    echo "
    server {
        listen 80;
        server_name $domain www.$domain ;

      location /git/ {
        proxy_redirect off;
        proxy_bind 127.0.0.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_pass http://127.0.0.1:3000/;
      }

      location / {
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_pass http://127.0.0.1:3000;
      }
    } " > /etc/nginx/sites-available/gogs

    ln -s /etc/nginx/sites-available/gogs /etc/nginx/sites-enabled/gogs

    systemctl restart nginx gogs mysql

    clear

    echo"
    Services status:
    `systemctl status nginx gogs mysql | egrep "service - |Active:"`


    Domain:   $domain

    #MySQL accsess:
    root / $root_pass
    gogs / $gogs_pass

    add to /etc/hosts : `ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1|xargs -n 6` $domain www.$domain
    Then go to http://$domain  need finish setup


    "

else
  echo "No parameters #1 found. "
fi
