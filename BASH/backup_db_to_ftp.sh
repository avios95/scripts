#!/bin/bash

dbrootpass=""
dbrootport="3306"
dbrootuser="root"
dbroothost="127.0.0.1"
userftp=""
hostftp=""
passftp=""
workdir="/root/db_backup_ftp"
logdir="/var/log"
logfile="backup.log"


if ! [ -d $workdir ]; then mkdir $workdir;  fi
echo "=========Backup DB start============" >> $logdir/$logfile

echo "=========`date`============" >> $logdir/$logfile
for i in $( mysql -u$dbrootuser -h$dbroothost -p$dbrootpass -P$dbrootport -e'show databases;' | egrep -iv "information_schema|Database|mysql|performance_schema");do
  mysqldump -u$dbrootuser -h$dbroothost -p$dbrootpass -P$dbrootport $i > $workdir/$i.sql 2>>$logdir/$logfile &&  echo ===dump $i done=== >> $logdir/$logfile  || echo "Dump db $i error"  >> $logdir/$logfile
done

for i in `ls -1 $workdir/*.sql`; do
        curl -p "ftp://$hostftp/backup_db/" --user "$userftp:$passftp" -Q "-RNFR /backup_db/$i.2" -Q "-RNTO /backup_db/$i.3"
        curl -p "ftp://$hostftp/backup_db/" --user "$userftp:$passftp" -Q "-RNFR /backup_db/$i.1" -Q "-RNTO /backup_db/$i.2"
        curl -p "ftp://$hostftp/backup_db/" --user "$userftp:$passftp" -Q "-RNFR /backup_db/$i" -Q "-RNTO /backup_db/$i.1"
        curl -T $i ftp://$userftp:$passftp@$hostftp/backup_db/  2>>$logdir/$logfile && echo "file $i sended" >> $logdir/$logfile || echo "Copy file $i error"  >> $logdir/$logfile
done
rm -rf $workdir*.sql
echo "=========Backup DB finish============" >> $logdir/$logfile
