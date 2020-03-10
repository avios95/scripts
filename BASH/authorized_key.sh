#!/bin/bash
#Author: 	avios
#Info:		Script added pub keys at file authorized_keys
clear
echo "==========Start=========="
if ! [ -d ~/.ssh/ ]; then mkdir ~/.ssh; echo "mkdir .ssh"; fi
if ! [ -f ~/.ssh/authorized_keys ]; then touch ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys ; echo "make file "authorized_key""; fi
if [[ "`cat ~/.ssh/authorized_keys | grep avios@ | awk '{print $3}' | grep "staff3" | uniq`" != "avios@staff3"* ]] ; then
echo -e "ssh-rsa AAAAB3NzBq/RjnJMQK+dG8c/kNHULmbPDIT0pLZpU7ytJRfOHD avios@server" >> ~/.ssh/authorized_keys
echo "add avios key"
else echo "avios key was added"
#if [[ "`cat ~/.ssh/authorized_keys | grep dave@ | awk '{print $3}' | grep "staff3" | uniq`" != "dave@staff3"*  ]] ; then
#echo -e "" >> ~/.ssh/authorized_keys
#echo "add dave key"
#else echo "dave key was added"
#fi
echo "==========Done==========="
