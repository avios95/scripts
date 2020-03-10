#!/bin/bash
if ! [ -d /root/scripts/ ]; then mkdir /root/scripts; echo "mkdir scripts"; fi
##############
cat << EOF > /etc/logrotate.d/oom
/var/log/oom.log {
  daily
  rotate 4
  missingok
}
EOF
logrotate -f /etc/logrotate.conf
logrotate -f /etc/logrotate.d/oom

echo "Setting rotation log compleate!"

######################################
cat << EOF > /root/scripts/oom.sh
#!/bin/bash
LOG="/var/log/oom"

echo ================== \`date \` ================================================================================================== >> \$LOG
w|head -n1 >> \$LOG
echo "" >> \$LOG

/usr/bin/free -m >> \$LOG
echo "">> \$LOG

/bin/ps axo rss,comm,pid | awk '{ proc_list[\$2] += \$1; } END { for (proc in proc_list) { printf("%d\t%s\n", proc_list[proc],proc); }}' | sort -n | tail -n 10 | sort -rn | awk '{\$1/=1024;printf "%.0fMB\t",\$1}{print \$2}' >> \$LOG
echo "" >> \$LOG

echo number of apaches processes \`ps aux|egrep 'httpd|apache'|wc -l\` >> \$LOG

if  [[ "\$(cat /var/log/messages|grep -i "Out of memory")" ]]; then
        cat /var/log/messages|grep -i "Out of memory"|tail -n2 >> \$LOG
        cat /dev/null>/var/log/messages
fi
EOF

chmod +x /root/scripts/oom.sh
echo "Make script oom.sh complete!"
#######
cat <(crontab -l) <(echo "*/2 * * * * /bin/bash /root/scripts/oom.sh") | crontab -
service crond restart
echo "Adding task in crontab compleate!"
