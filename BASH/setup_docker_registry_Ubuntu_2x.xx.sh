#!/bin/bash

if [ -n "$1" ]
then
    domain=$1
    workdir="/opt/docker-registry"

    apt-get update -y
    apt-get upgrade -yfi
    apt-get install curl -y
    curl -sSL https://get.docker.com/ | sh
    curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    apt-get install pwgen git nginx apache2-utils -y



    mkdir -p $workdir/data
    mkdir -p $workdir/auth

    echo "
    version: '3'

    services:
      registry:
        restart: always
        image: registry:2
        ports:
        - \"5000:5000\"
        environment:
          REGISTRY_AUTH: htpasswd
          REGISTRY_AUTH_HTPASSWD_REALM: Registry
          REGISTRY_AUTH_HTPASSWD_PATH: /auth/registry.password
          REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
        volumes:
          - ./auth:/auth
          - ./data:/data
    " > $workdir/data/docker-compose.yml



    echo "
    server {
        listen 80;
        server_name $domain www.$domain ;
        client_max_body_size 0;
        location / {
            if (\$http_user_agent ~ \"^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$\" ) {
              return 404;
            }

            proxy_pass                          http://localhost:5000;
            proxy_set_header  Host              \$http_host;   # required for docker client's sake
            proxy_set_header  X-Real-IP         \$remote_addr; # pass on real client's IP
            proxy_set_header  X-Forwarded-For   \$proxy_add_x_forwarded_for;
            proxy_set_header  X-Forwarded-Proto \$scheme;
            proxy_read_timeout                  900;
        }
    } " > /etc/nginx/sites-available/dockerregistry

    ln -s /etc/nginx/sites-available/dockerregistry /etc/nginx/sites-enabled/dockerregistry


    cd $workdir/data/ ; docker-compose up -d
    systemctl restart nginx
    systemctl enable nginx

    echo "">>$workdir/data/auth/registry.password
    regadmin_pass=`pwgen -s 16 1`
    htpasswd -Bb  $workdir/data/auth/registry.password regadmin $regadmin_pass


    clear

    echo "Services status:
    `systemctl status nginx | egrep "service - |Active:"`"
    echo "

    Domain:   $domain

    #Acsess to  docker registry
    regadmin / $regadmin_pass


    add to /etc/hosts :
    `ip a|grep inet|egrep -vi "(127.0.0|::|tun)"|awk '{print $2}'|cut -d "/" -f 1|xargs -n 6` $domain www.$domain

    Go to http://$domain/v2  need check work, result neded {}


    How use:
    PUSH
    1.create image from docker comtainer
    docker commit ***** test-image
    2.Login to  docker registry
    docker login http://$domain
    3.Rename image to your name registry
    docker tag test-image $domain/test-image
    4.Push
    docker push $domain/test-image

    PULL&RUN
    docker login http://$domain
    docker pull $domain/test-image
    docker run -it $domain/test-image /bin/bash


    "

else
  echo "No parameters #1 found. "
fi
