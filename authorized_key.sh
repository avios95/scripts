#!/bin/bash
#Author: 	avios
#Github: 	https://github.com/avios95/script/blob/master/authorized_key.sh
#Example:	wget https://raw.githubusercontent.com/avios95/script/master/authorized_key.sh && bash authorized_key.sh && rm -rf authorized_key.sh 
#Info:		Script added pub keys at file authorized_keys
clear
echo "==========Start=========="
if ! [ -d /root/.ssh/ ]; then mkdir /root/.ssh; echo "mkdir .ssh"; fi 
if ! [ -f /root/.ssh/authorized_keys ]; then touch /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys ; echo "make file "authorized_key""; fi
if [ "`cat /root/.ssh/authorized_keys | grep avios@ | awk '{print $3}'`" != "avios@staff.uadmin.net"  ] ; then 
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCt/fsm3zlONojgVOHaQm1xGyZrxGnFpIFIq2vU9hxoLEkygQ5/OIn3oYFNdVT6kz16FQ6w4myeEVJxJBtMMj0Ni1n7noQ5TYLHT5a+LE11v+UNHUhm2s3ehT6D6JZu7cgPoQZRD4mTV61WVw+7L+TIMqyW6iAe9Irn/0P8rtthFE2VIloPqTmYJAKop9hIjPaSjCq7FNIBSONJz6yp0batavnVP2vWvBMiPrHibJ+7s7aiPPlOqkmKagOXYF2C/WjrIjiKkInXsYi5fcvjDBI8+Xo+9mNNmEg8HWeQh6xv6KRFnzG+i8XgVfzMixFMTjTmOdb0pmE15biLfmQyI5zj avios@staff.uadmin.net" >> .ssh/authorized_keys 
echo "add avios key"
else echo "avios key was added"
fi
if [ "`cat /root/.ssh/authorized_keys | grep dave@ | awk '{print $3}'`" != "dave@staff.uadmin.net"  ] ; then 
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDa1EVTL5M3RsHxF5tSq2Sev9o3iwC11XlpfrvNUPcNJjJMBIQkuuwFOKY1gfTQhSKgO8Lnc3/3nr9Vbz9iy+ViM1eHTOKRwCEGeUz1PUeSxu/i6CJ/SWz7qPOGU8PqKmv9QsL0XEw5xU7AAVdIK/NHM2kxw/YmVxHofY8ru2tFIanXLU1C4hVqzYl37t26XS6PuPCwbwzSQ8KLXXOSXNQGi9XsCRa1CIDhgHhsa3L6QymmgJLIaBm3lwfu6IDtI6MgHJTPps8AMaq1xLKvI8RL4cPU4T+jCj5h5hjYrKCwxHK/NMDMFIcRHnVjJOhx9iCq/FQHFacMDEF2wUGnzYTn dave@staff.uadmin.net" >> .ssh/authorized_keys 
echo "add dave key"
else echo "dave key was added"
fi
if [ "`cat /root/.ssh/authorized_keys | grep kozyr@ | awk '{print $3}'`" != "kozyr@staff.uadmin.net"  ] ; then 
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDG73K9T9Oi/xfdvrEKFa32FpC20tJcOuF2v64ImdUXF7J8b82p5ErajASGchzX8cz01jGz+I40+0TyW6tJNMqW3Wq9qjyy7xinR95TgUtSyfCwEqqM7WAKxnPrvRFCG+cFL9ub4/xiw2xuoUueKgsrHNFbLuNmid7yTe0wdNKTKjG7S3d9mKRSNtfEWP9DRCpb51+IzvVgE9a8p8nngnDYCvKiX3QBF9lNwDZ0Y5a9NOFkLqduf5RYNkibOmceOuaUYzcOxxf1JUgBvGbXZM+eRksF5R86obzBz7JxeyK++GPKmjU0piwOw3+Ow/WYvLISuC8RAyJOLSTMZMKNlLdx kozyr@staff.uadmin.net" >> .ssh/authorized_keys 
echo "add kozyr key"
else echo "kozyr key was added"
fi
if [ "`cat /root/.ssh/authorized_keys | grep sum41k@ | awk '{print $3}'`" != "sum41k@staff.uadmin.net"  ] ; then 
echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDN26aq5STu4yiGtDVGToEiV3ebd7zOCqUj9vZ7IFWHeOxZ64Kj3TpHPPXsL/vP7RfoAmy9ZjJfSo52QxcF9lIpHdQ6lbvzv8jz5O88kozLFDUWO5EynhhdTlJqa8ygc0bYtiybBN2IQmELs3HwW5cjNThH8XdGOiOfZQ04eKUAQ1aocXnv3UAUljdvgwPdN/2FjcUoK49wBm6GSEDE2yEki6TqVsLV34WJynJtcg1J4VpFMU4g/zj4+hUXU1lQuCJJQ2wYN03QsZYWU8vvarbAbCmt7gxQeTBM53GZ/xkqav8qkxYENJr06WcDPIKX44+7luFbP1C28Uu/ldK6ZSWl sum41k@staff.uadmin.net" >> .ssh/authorized_keys 
echo "add sum41k key"
else echo "sum41k key was added"
fi
echo "==========Done==========="
