#!/bin/bash
#
#  https://github.com/dave-pl/linux_bash_hwcheck/blob/master/smart.sh   -- оригинал
#  https://gist.github.com/hanynowsky/b0bf3b8e451aeb00e5741385a2923fac  -- список как опредилить рейд контролер
#  https://github.com/avios95/script/blob/master/SMART_smartctl.sh     -- мой файл
#
smart () {
#==========Блок обнаружения=============Detect block=======================

#функция будет проверять сколько RAID bus controller выведет lspci , потом пощитает сколько уникальных и выведет их количество.
if [[ `lspci|grep -i "RAID bus controller"|uniq|wc -l` -eq 0  ]]; then
	if [[ "-n $(fdisk -l 2>/dev/null|grep /dev/nvme)" && "-n $(lsblk|grep nvme)" ]];then
		echo "====== Intel NVMe detected ======" 
		raidcard=nvme
	else
		echo "====== No raid controller detected ======" 
		raidcard=NoRaid
	fi
elif [[ `lspci|grep -i "RAID bus controller" | uniq |wc -l` -eq 1 ]]; then
	if [[ -n `lspci|grep -i "RAID bus controller"|grep "MegaRAID"` && `smartctl --scan|grep -i megaraid` ]]; then
		echo "====== MegaRAID raid controller detected ======"
		raidcard=MegaRAID
	elif [[ -n `lspci|grep -i "RAID bus controller"|grep "Hewlett-Packard"`]]; then
		echo "====== Hewlett-Packard raid controller detected ======"
		raidcard=Hewlett-Packard
		
#При добавление нового RAID контролера заменить newRAIDcontroler на новое имя.
#Нагуглил еще Adaptec RAID, HighPoint RocketRAID, 3Ware RAID Controller, LSI RAID Controller, Areca ---- поищу как их тестить и добавлю.
	elif [[ -n `lspci|grep -i "RAID bus controller"|grep "new_RAID_controler"`]]; then
		echo "====== new_RAID_controler raid controller detected ======"
		raidcard=new_RAID_controler
	else
		echo "I don't know this raid controller"
	fi
elif [[ `lspci|grep -i "RAID bus controller" | uniq |wc -l` -ge 2 ]]; then 
		echo "RAID controller detected more 2 or 2"
#Можно здесь написать функцию чтоб все обнаруженые Raid контролеры, должны быть проверены по одному. и проверены соответственно модели.
else 
	echo ""Error in script. Comand "lspci|grep -i "RAID bus controller" | uniq | wc -l" ===" `lspci|grep -i "RAID bus controller" | uniq | wc -l`"
fi	
}
#==========Блок обнаружения=============Detect block=======================

#==========Блок исполнения=================run block=======================
#потом для каждого варианта/модели через case сделать автоматизированую проверку SMART теста.

#==========Блок исполнения=================run block=======================

smart
