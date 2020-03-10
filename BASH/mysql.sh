#!/bin/bash
#Author: 	avios
#Github:
#Example:
#Info:		Скрипт проверяет статус mysql, если он незапущен то перезапустить, и чекнуть бызы
#         Необхдимо улутшить: проверка сервиса мускуля(mysql mariadb), возможно добавить проверку еще служб, добавить вывод логов на OOM(как причины падение mysql), уведомление на пошту
status=$(mysqladmin ping)
if [[ $status != "mysqld is alive" ]]; then
/usr/bin/systemctl restart httpd && echo "httpd has been restarted"
/usr/bin/systemctl restart mariadb && echo "mysql has been restarted"
/usr/bin/mysqlcheck -r -A
fi


status=$(/usr/bin/systemctl status puma.service | grep Active: | awk '{print $2}')
if [[ $status == "failed" ]]; then
/usr/bin/systemctl restart puma.service && echo "puma.service has been restarted"
fi
