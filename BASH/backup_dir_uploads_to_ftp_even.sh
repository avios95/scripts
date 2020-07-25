#!/bin/bash
userftp=""
hostftp=""
passftp=""

workdir="/home/user/domains/domain.net/public_html/uploads/"
logdir="/var/log"
logfile="backup.log"

echo "=========Backup dir $workdir start============" >> $logdir/$logfile
for i in $(ls -1 $workdir | grep monthly_`date +%Y_%m`) ; do

    wput $workdir/$i ftp://$userftp:$passftp@$hostftp/upload_even/ 2>>$logdir/$logfile && echo "Files from $workdir is sended" >> $logdir/$logfile || echo "Copied files from $workdir finished with error"  >> $logdir/$logfile

done
echo "=========Backup dir $workdir finish============" >> $logdir/$logfile
