#!/bin/bash
MYSQL=`which mysql`
MYSQLDUMP=`which mysqldump`
MYSQLSHOW=`which mysqlshow`
echo -e "Database\tTable"

if [ -n "$1" ]
then
  if [ -n "$2" ]
  then
    if [ -n "$3" ]
    then
      d=$1
      u=$2
      p=$3
      for i in $($MYSQL -u $u -p$p -e "SHOW TABLES FROM $d" | egrep 'rot_gallery_stats|rot_gallery_info|rot_galleries'); do
          if [ "InnoDB" != $($MYSQLSHOW -i -u $u -p$p $d  |grep $i | awk '{print $4}') ]
          then
            echo -e "$d\t$i";
            $MYSQL -u$u -p$p -e "use $d; alter table $i ENGINE = INNODB;" ;
          else
            echo "Engine $d table $i already InnoDB"
          fi
      done
    else
      echo "No parameters #3 found. "
    fi
  else
    echo "No parameters #2 found. "
  fi
else
  echo "No parameters #1 found. "
fi
