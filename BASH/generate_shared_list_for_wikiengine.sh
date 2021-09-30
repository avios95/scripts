#!/bin/bash

#Header
echo "
{| class=\"wikitable\"
! Location
! SystemID
! Main IP
! CP
! OS
! Ticket
! Reseller
! Additional IP"

oldip="123.123.123.123"
ip="123.123.123.123"
oldaddip=""

#shareds
while read shared; do
    ip=`echo $shared| awk '{print $3}'`
    if [ $ip != $oldip ]
        then
            if [ $oldip = "123.123.123.123" ];
                then
                    oldip=""
                else
                    echo "|-"
                    echo "| $oldloc $loc"
                    echo "| $oldname $hostname"
                    echo "| $oldip"
                    echo "| [http://$oldip:2222 DA]"
                    echo "| $OS"
                    echo "| "
                    echo "| Amhost"
                    echo "| $oldaddip"
                    oldaddip=""
            fi
    fi
    oldip=$ip
    oldloc=`echo $shared| awk '{print $1}'`
    oldname=`echo $shared| awk '{print $2}'`
    oldaddip="$oldaddip"`echo $shared| awk '{print $4}'`","
    OS=`grep -ri "$ip" shared.new2 | awk '{print $4}'`
    hostname=`grep -ri "$ip" shared.old | awk '{print $4}'`
    loc=`grep -ri "$ip" shared.old | awk '{print $3}'`
done < shared.new

#End
echo "|-
|}
"

#Incomin tables
#NL	ns-999	123.123.195.6	123.123.195.6
#NL	ns-999	123.123.195.6	123.123.195.7

