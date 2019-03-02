#!/bin/bash
#Author: 	avios
#Github: 	https://github.com/avios95/script/blob/master/Install_app.sh
#Example:	wget https://raw.githubusercontent.com/avios95/script/master/Install_app.sh && bash Install_app.sh && rm -rf Install_app*
#Info:		Install app with repository and configure system

echo -e "\e[31mInstal wget\e[0m"
apt-get install -y wget

#Start repository
echo -e "\e[31mAdd repository atom\e[0m"
add-apt-repository ppa:webupd8team/atom
echo -e "\e[31mAdd repository flameshot\e[0m"
add-apt-repository ppa:atareao/flameshot
echo -e "\e[31mAdd repository Notepad++\e[0m"
add-apt-repository -y ppa:notepadqq-team/notepadqq
echo -e "\e[31mAdd repository Tor\e[0m"
add-apt-repository -y ppa:webupd8team/tor-browser
echo -e "\e[31mAdd repository Telegram\e[0m"
add-apt-repository -y ppa:atareao/telegram
echo -e "\e[31mAdd repository SublimeText\e[0m"
add-apt-repository -y ppa:webupd8team/sublime-text-3
echo -e "\e[31mAdd repository LibreOffice\e[0m"
add-apt-repository -y ppa:libreoffice/ppa
echo -e "\e[31mAdd repository Firefox\e[0m"
add-apt-repository -y ppa:mozillateam/firefox-next
echo -e "\e[31mAdd repository Thunderbird\e[0m"
add-apt-repository -y ppa:mozillateam/thunderbird-next
echo -e "\e[31mAdd repository CherryTree\e[0m"
add-apt-repository -y ppa:giuspen/ppa

echo -e "\e[31mAdd repository Opera\e[0m"
wget -q -O - http://deb.opera.com/archive.key | apt-key add -
sh -c 'echo "deb http://deb.opera.com/opera-stable/ stable non-free" >> /etc/apt/sources.list.d/opera.list'

echo -e "\e[31mAdd repository Skype\e[0m"
wget -q -O - https://repo.skype.com/data/SKYPE-GPG-KEY | apt-key add -
sh -c 'echo "deb [arch=amd64] https://repo.skype.com/deb unstable main" >> /etc/apt/sources.list.d/skype-unstable.list'

echo -e "\e[31mAdd repository Google Chrome\e[0m"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'

echo -e "\e[31mAdd repository VirtualBox\e[0m"
wget -q -O - https://www.virtualbox.org/download/oracle_vbox_2016.asc | apt-key add -
sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian xenial contrib" >> /etc/apt/sources.list.d/virtualbox.org.list'

echo -e "\e[31mAdd repository Dropbox\e[0m"
apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sh -c 'echo "deb http://linux.dropbox.com/ubuntu/ xenial main" >> /etc/apt/sources.list.d/dropbox.list'
#End repository

echo -e "\e[31mStart Update\e[0m"
apt-get update
echo -e "\e[31mEnd Update\e[0m"

#Install app
echo -e "\e[31mInstal atom\e[0m"
apt-get install atom
echo -e "\e[31mInstal git\e[0m"
apt-get install git
echo -e "\e[31mInstal remmina\e[0m"
apt-get install remmina remmina-plugin-rdp libfreerdp-plugins-standard remmina-plugin-vnc
echo -e "\e[31mInstal pwgen\e[0m"
apt-get install pwgen
echo -e "\e[31mInstal lftp\e[0m"
apt-get install lftp
echo -e "\e[31mInstal traceroute\e[0m"
apt-get install traceroute
echo -e "\e[31mInstal kazam\e[0m"
apt-get install kazam
echo -e "\e[31mInstal flameshot\e[0m"
apt-get install flameshot
echo -e "\e[31mInstal tree\e[0m"
apt-get install -y tree
echo -e "\e[31mInstal atop\e[0m"
apt-get install -y atop
echo -e "\e[31mInstal 2ping\e[0m"
apt-get install -y 2ping
echo -e "\e[31mInstal whois\e[0m"
apt-get install -y whois
echo -e "\e[31mInstal Vim\e[0m"
apt-get install -y vim
echo -e "\e[31mInstall cURL\e[0m"
apt-get install -y curl
echo -e "\e[31mInstall Notepad++\e[0m"
apt-get install -y notepadqq
echo -e "\e[31mInstall Tor\e[0m"
apt-get install -y tor-browser
echo -e "\e[31mInstall Telegram\e[0m"
apt-get install -y telegram
echo -e "\e[31mInstall Google Chrome\e[0m"
apt-get install -y google-chrome-stable
echo -e "\e[31mInstall Chromium\e[0m"
apt-get install -y chromium-browser
echo -e "\e[31mInstall SublimeText\e[0m"
apt-get install -y sublime-text-installer
echo -e "\e[31mInstall Libreoffice\e[0m"
apt-get install -y libreoffice
echo -e "\e[31mInstall Opera\e[0m"
apt-get install -y opera
echo -e "\e[31mInstall Skype\e[0m"
apt-get install -y skypeforlinux
echo -e "\e[31mInstall virtualbox-5.2\e[0m"
apt-get install -y virtualbox-5.2
echo -e "\e[31mInstall Dropbox\e[0m"
apt-get install -y dropbox
echo -e "\e[31mInstall FileZilla\e[0m"
apt-get install -y filezilla
echo -e "\e[31mInstall Firefox\e[0m"
apt-get install -y firefox
echo -e "\e[31mInstall Thunderbird\e[0m"
apt-get install -y thunderbird
echo -e "\e[31mInstall Pidgin\e[0m"
apt-get install -y pidgin
echo -e "\e[31mInstall CherryTree\e[0m"
apt-get install -y cherrytree
echo -e "\e[31mInstall Viber\e[0m"
apt-get install libqt5gui5 libcurl3 -y
wget http://download.cdn.viber.com/cdn/desktop/Linux/viber.deb
dpkg -i viber.deb
rm -rf viber.deb
echo -e "\e[31mApp instaled\e[0m"

#Добавления рабочего стола в Dropbox для синхронизации
cd ~
mkdir Dropbox
if [ -d ~/Рабочий\ стол ]; then
ln -s ~/Рабочий\ стол ~/Dropbox/Рабочий\ стол
echo -e "\e[31mSymlink ru added\e[0m"
elif [ -d ~/Desktop ]; then
ln -s ~/Desktop ~/Dropbox/Рабочий\ стол
echo -e "\e[31mSymlink en added\e[0m"
else
echo -e "\e[31mNo directories\e[0m"
fi
chown -R avios. ~/Dropbox
#

#clean system
echo -e "\e[31mautoclean\e[0m"
apt-get autoclean
echo -e "\e[31mautoremove\e[0m"
apt-get autoremove -y
echo -e "\e[31mclean\e[0m"
apt-get clean
echo -e "\e[31minstall -f\e[0m"
apt-get install -f -y
