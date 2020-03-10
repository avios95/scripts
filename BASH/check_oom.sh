#!/bin/bash
if ! [ -d /root/scripts/ ]; then mkdir /root/scripts; echo "mkdir scripts"; fi

echo -e "/var/log/oom.log {
  daily
  rotate 4
  missingok
}
" > /etc/logrotate.d/oom
logrotate /etc/logrotate.conf
logrotate -f /etc/logrotate.d/oom

echo "Setting rotation log compleate!"

echo \#\!/bin/bash > /root/scripts/oom.sh
echo -e "
echo ================== \`date\` ================ >> /var/log/oom.log
w | head -n1  >> /var/log/oom.log
/usr/bin/free -m >> /var/log/oom.log
echo \"\">> /var/log/oom.log
" >> /root/scripts/oom.sh

echo "/bin/ps axo rss,comm,pid | awk '{ proc_list[\$2] += \$1; } END { for (proc in proc_list) { printf(\"%d\\t%s\\n\", proc_list[proc],proc); }}' | sort -n | tail -n 10 | sort -rn | awk '{\$1/=1024;printf \"%.0fMB\t\",\$1}{print \$2}' >> /var/log/oom.log" >> /root/scripts/oom.sh

echo -e "
echo \"\">> /var/log/oom.log
echo number of apaches processes \`ps aux|egrep 'httpd|apache'|wc -l\` >> /var/log/oom.log
cat /var/log/messages|grep -i \"Out of memory\"  >> /var/log/oom.log

" >> /root/scripts/oom.sh

echo "Make script oom.sh compleate!"

cat <(crontab -l) <(echo "*/2 * * * * /bin/bash /root/scripts/oom.sh") | crontab -
echo "Adding task in crontab compleate!"
