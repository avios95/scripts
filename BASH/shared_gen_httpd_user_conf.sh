#!/bin/bash
user=$1
for domain in `cat /usr/local/directadmin/data/users/$user/domains.list` ; do
ip=`cat /usr/local/directadmin/data/users/$user/domains/$domain.ip_list` ;
ssl=`cat /usr/local/directadmin/data/users/$user/domains/$domain.conf | grep ^ssl`;
echo "
<VirtualHost $ip:8080 127.0.0.1:8080 >
        <IfModule vhost_limit_module>
                MaxVhostClients 25
        </IfModule>
        ServerName www.$domain
        ServerAlias www.$domain $domain
        ServerAdmin webmaster@$domain
        DocumentRoot /home/$user/domains/$domain/public_html
        ScriptAlias /cgi-bin/ /home/$user/domains/$domain/public_html/cgi-bin/
        UseCanonicalName OFF
        <IfModule vhost_limit_module>
                MaxVhostClients 25
        </IfModule>
        <IfModule \!mod_ruid2.c>
                SuexecUserGroup $user $user
        </IfModule>
        <IfModule mod_ruid2.c>
                RMode config
                RUidGid $user $user
                RGroups @none
        </IfModule>
        CustomLog /var/log/httpd/domains/$domain.bytes bytes
        CustomLog /var/log/httpd/domains/$domain.log combined
        ErrorLog /var/log/httpd/domains/$domain.error.log
        <Directory /home/$user/domains/$domain/public_html>
                php_admin_flag engine ON
                php_admin_value sendmail_path '/usr/sbin/sendmail -t -i -f $user@$domain'
                php_admin_value mail.log /home/$user/.php/php-mail.log
        </Directory>
</VirtualHost>
" >>  /usr/local/directadmin/data/users/$user/httpd.conf
if [ "$ssl" != "ssl=ON"  ] ; then
        echo ssl off
else
        echo  ssl on
        echo "
<VirtualHost $ip:8081 127.0.0.1:8081 >
        <IfModule vhost_limit_module>
                MaxVhostClients 25
        </IfModule>
        SSLEngine on
        SSLCertificateFile /etc/httpd/conf/ssl.crt/server.crt
        SSLCertificateKeyFile /etc/httpd/conf/ssl.key/server.key
        SSLCACertificateFile /etc/httpd/conf/ssl.crt/server.ca
        ServerName www.$domain
        ServerAlias www.$domain $domain
        ServerAdmin webmaster@$domain
        DocumentRoot /home/$user/domains/$domain/public_html
        ScriptAlias /cgi-bin/ /home/$user/domains/$domain/public_html/cgi-bin/
        UseCanonicalName OFF
        <IfModule vhost_limit_module>
                MaxVhostClients 25
        </IfModule>
        <IfModule \!mod_ruid2.c>
                SuexecUserGroup $user $user
        </IfModule>
        <IfModule mod_ruid2.c>
                RMode config
                RUidGid $user $user
                RGroups @none
        </IfModule>
        CustomLog /var/log/httpd/domains/$domain.bytes bytes
        CustomLog /var/log/httpd/domains/$domain.log combined
        ErrorLog /var/log/httpd/domains/$domain.error.log
        <Directory /home/$user/domains/$domain/private_html>
                php_admin_flag engine ON
                php_admin_value sendmail_path '/usr/sbin/sendmail -t -i -f $user@$domain'
                php_admin_value mail.log /home/$user/.php/php-mail.log
        </Directory>
</VirtualHost>
" >>  /usr/local/directadmin/data/users/$user/httpd.conf
fi
sed -i"" "s#IfModule\ \\\#IfModule\ #g" /usr/local/directadmin/data/users/$user/httpd.conf 
echo $domain $user $ip done
done
