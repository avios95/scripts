#!/bin/bash
userftp=""
hostftp=""
passftp=""

workdir="/home/user/domains"
logdir="/var/log"
logfile="backup.log"

echo "=========Backup dir $workdir start============" >> $logdir/$logfile

wput -u $workdir/ ftp://$userftp:$passftp@$hostftp/domains_odd/ 2>>$logdir/$logfile && echo "Files from $workdir is sended" >> $logdir/$logfile || echo "Copied files from $workdir finished with error"  >> $logdir/$logfile

echo "=========Backup dir $workdir finish============" >> $logdir/$logfile
