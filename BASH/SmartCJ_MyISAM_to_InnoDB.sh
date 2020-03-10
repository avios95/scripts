#!/bin/bash
MYSQL=`which mysql`

if [ -d /etc/webmin ]; then
  PANEL=vm
  USER=root
  PASS=$(cat /etc/webmin/mysql/config |grep pass=|cut -f 2 -d "=")
elif [ -d /usr/local/vesta ]; then
  PANEL=vc
  USER=root
  PASS=$(cat /usr/local/vesta/conf/mysql.conf |awk '{print $3}'|cut -f 2 -d "'")
elif [ -d /usr/local/directadmin ]; then
  PANEL=da
  USER=da_admin
  PASS=$(cat /usr/local/directadmin/conf/mysql.conf|grep passwd|cut -f 2 -d "=")
elif [ -d /usr/local/mgr5 ]; then
  PANEL=isp
  USER=root
  PASS=$(cat /root/.my.cnf|grep password|awk '{print $3}')
fi

echo -e "$PANEL\n$USER\n$PASS\n"
echo -e "Database\tTable"
#Выводим наши таблицы и коневертируем их
if [ -n "$1" ]
then
  d=$1
  for i in $($MYSQL -u $USER -p$PASS -e "SHOW TABLES FROM $d" | egrep 'rot_gallery_stats|rot_gallery_info|rot_galleries'); do
    if [ "InnoDB" != $($MYSQLSHOW -i $d |grep $i | awk '{print $4}') ]
    then
      echo -e "$d\t$i";
      $MYSQL -u$USER -p$PASS -e "use $d; alter table $i ENGINE = INNODB;" ;
    else
      echo "Engine $d table $i already InnoDB"
    fi
  done
else
  echo "No parameters found. "
  for d in $($MYSQL -u $USER -p$PASS -e "show databases"|grep -v Database);do
    for i in $($MYSQL -u $USER -p$PASS -e "SHOW TABLES FROM $d" | egrep 'rot_gallery_stats|rot_gallery_info|rot_galleries'); do
      if [ "InnoDB" != $($MYSQLSHOW -i $d |grep $i | awk '{print $4}') ]
      then
        echo -e "$d\t$i";
        $MYSQL -u$USER -p$PASS -e "use $d; alter table $i ENGINE = INNODB;" ;
      else
        echo "Engine $d table $i already InnoDB"
      fi
    done
  done
fi
