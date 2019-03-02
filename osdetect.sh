#!/bin/sh
# wget https://raw.githubusercontent.com/avios95/script/master/osdetect.sh && bash osdetect.sh && rm -rf osdetect*


os=$(uname -s)
dist_name='unknown'
dist_version='unknown'

case "${os}" in
    'Linux')
	lsb_release_path=$(which lsb_release 2> /dev/null)
	if [ "${lsb_release_path}1" != "1" ]; then
	    dist_name=$(${lsb_release_path} -i | cut -d ':' -f2 )
	    dist_version=$(${lsb_release_path} -r | cut -d ':' -f2 | sed 's/\t *//g')
	else
	    if [ -r '/etc/debian_version' ]; then
		      if [ -r '/etc/dpkg/origins/ubuntu' ]; then
		          dist_name='ubuntu'
		      else
		          dist_name='debian'
	        fi
	    dist_version=$(cat /etc/debian_version | sed s/.*\///)
      elif [ -r '/etc/redhat-release' ]; then
          if [ "$(cat /etc/redhat-release | grep -i 'Red Hat Enterprise')2" != "2" ]; then
              dist_name='rhel'
          else
              dist_name=$(cat /etc/redhat-release | cut -d ' ' -f1)
          fi
              dist_version=$(cat /etc/redhat-release | sed 's/.*release\ //' | sed 's/\ .*//' )
      fi
	fi
    ;;
    * )
    echo "I don't know this OS: `uname -s` `uname -m`"
    ;;
esac
echo "$dist_name $dist_version"
