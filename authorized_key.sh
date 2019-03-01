#!/bin/bash

if ! [ -d /root/.ssh/ ]; then mkdir /root/.ssh; fi 
if ! [ -f /root/.ssh/authorized_keys ]; then touch /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys ; fi
if [ "`cat ~/.ssh/authorized_keys | grep avios@ | awk '{print $3}'`" != "avios@staff.uadmin.net"  ]
then echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt/fsm3zlONojgVOHaQm1xGyZrxGnFpIFIq2vU9hxoLEkygQ5/OIn3oYFNdVT6kz16FQ6w4myeEVJxJBtMMj0Ni1n7noQ5TYLHT5a+LE11v+UNHUhm2s3ehT6D6JZu7cgPoQZRD4mTV61WVw+7L+TIMqyW6iAe9Irn/0P8rtthFE2VIloPqTmYJAKop9hIjPaSjCq7FNIBSONJz6yp0batavnVP2vWvBMiPrHibJ+7s7aiPPlOqkmKagOXYF2C/WjrIjiKkInXsYi5fcvjDBI8+Xo+9mNNmEg8HWeQh6xv6KRFnzG+i8XgVfzMixFMTjTmOdb0pmE15biLfmQyI5zj avios@staff.uadmin.net" >> .ssh/authorized_keys 
echo "added avios key"
fi
ls -l .ssh/authorized_keys
