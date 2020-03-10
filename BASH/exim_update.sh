#!/bin/bash

if [[ -d /usr/local/mgr5/ ]] || [[ -d /usr/local/vesta/ ]]; then
  mkdir /root/backups_`date +%F` && tar cvzf /root/backups_`date +%F`/etc.tar.gz /etc \
  && yum -y update exim && service exim restart && exim -bp | awk '/^ *[0-9]+[mhd]/{print "exim -Mrm " $3}' | bash && service exim status \
  && exim -bV|grep "Exim version"
fi
if [[ -d /usr/local/directadmin/ ]];then
  mkdir /root/backups_`date +%F` && tar cvzf /root/backups_`date +%F`/etc.tar.gz /etc \
  && cd /usr/local/directadmin/custombuild \
  && yum install -y db4-devel cyrus-sasl-devel perl-ExtUtils-Embed \
  && ./build update \
  && ./build set exim yes \
  && ./build exim \
  && service exim restart && exim -bp | awk '/^ *[0-9]+[mhd]/{print "exim -Mrm " $3}' | bash && service exim status \
  && exim -bV|grep "Exim version" 
fi
