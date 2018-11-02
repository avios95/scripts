#!/bin/bash
chkmemory () {
		#autostart_Memtester
		echo "autostart_Memtester"
		for (( i=1;; i++ ))
		do	
			sleep 3s
			freeKB=`grep -r MemFree /proc/meminfo| awk '{print $2}'`
			let freeMB=$freeKB/1024
			echo "Free memory: " $freeMB"MB"

		if [[ "$freeMB" -ge "2048" ]]
		then
			memtester 1G 1 >> /home/vadim/Рабочий\ стол/memtest/memtest_$i.log &
			echo "Run memtester 1G #$i"

		#останется кусок памяти который будет меньше 1G но больше 512М
		#elif [[ "$freeMB" -ge "1024" ]] ; then   
		#	memtester 512M 1 >> /home/vadim/Рабочий\ стол/memtest/memtest1024_$i.log &
		#    echo "Run memtester 512M #$i" 
		#останется кусок памяти который будет меньше 1G но больше 512М

		##запустить мемтест на остальную память оставить только 512M
		elif [[ "$freeMB" -ge "1024" ]] ; then   
			let	lastfree=$freeMB-512
			echo "lastfree=$lastfree MB"
			memtester $lastfree 1 >> /home/vadim/Рабочий\ стол/memtest/memtest_$i.log &
			echo "Run memtester $lastfree MB#$i" 
		##запустить мемтест на остальную память оставить только 512M


		else
			echo "====================wait memtester the end=================="
			sleep 1s
			break
		fi
		done
			}

chkmemory

