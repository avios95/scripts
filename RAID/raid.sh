#!/bin/bash


# Initialise
RAID_LEVEL=""
RAID_STRIPE_SIZE=""
RAID_DRIVE_COUNT=""

# Detect cards
echo " INFO: Searching for controllers and volume parameters, this may take some time"
if [[ $(lspci | grep '3ware Inc') ]]; then
  #### 3ware ####
  echo " INFO: Detected 3ware controller"

  controller=$(tw_cli show | sort -rn -k 4 | head -n 1)
  controllernum=$(echo $controller | awk '{ print $1 }')
  raidlevel=$(tw_cli /$controllernum show | grep RAID-[56])
  unitnum=$(echo $raidlevel | sort -k 7 | head -n 1 | awk '{ print $1 }')
  unit=$(tw_cli /$controllernum/$unitnum show)

  # RAID Level
  RAID_LEVEL=$(echo $raidlevel | grep -o RAID-[56] | cut -d \- -f 2)

  # Stripe Size
  RAID_STRIPE_SIZE=$(tw_cli /$controllernum show | grep "^$unitnum " | awk '{ print $6 }' | grep -o '[0-9]\+')

  # Number of drives
  RAID_DRIVE_COUNT=$(echo "$unit" | grep "DISK" | wc -l)


elif [[ $(lspci | grep 'Adaptec AAC-RAID') ]]; then
  #### Adaptec ###
  # Makes the assumption that there is only one controller and the data array is logical drive 1
  echo " INFO: Detected Adaptec controller"

  # RAID Level
  RAID_LEVEL=$(arcconf getconfig 1 ld 1 | grep 'RAID level' | grep -o '[0-9]\+')

  # Stripe Size
  RAID_STRIPE_SIZE=$(arcconf getconfig 1 ld 1 | grep 'Stripe-unit size' | grep -o '[0-9]\+')

  # Number of drives
  RAID_DRIVE_COUNT=$(arcconf getconfig 1 ld 1 | grep Segment | wc -l)


elif [[ $(lspci | grep 'Areca Technology Corp') ]]; then
  #### Areca ####
  echo " INFO: Detected Areca controller"

  volnum=$(areca_cli vsf info | grep ARC | sort -rn -k 8 | head -n 1 | awk '{ print $1 }')
  volinf=$(areca_cli vsf info vol=$volnum)

  # RAID Level
  RAID_LEVEL=$(echo "$volinf" | grep "Raid Level" | grep -o '[0-9]\+')

  # Stripe Size
  RAID_STRIPE_SIZE=$(echo "$volinf" | grep "Stripe Size" | grep -o '[0-9]\+')

  # Number of drives
  RAID_DRIVE_COUNT=$(echo "$volinf" | grep "Member Disks" | grep -o '[0-9]\+')


elif [[ $(lspci | grep 'MPT SAS') ]]; then
  #### LSI MPT SAS ####
  echo " INFO: Detected LSI MPT SAS controller"

  echo "ERROR: Auto-detection currently un-supported"
  exit 1


elif [[ $(lspci | grep 'LSI MegaSAS') || $(lspci | grep 'Symbios Logic MegaRAID') ]]; then
  #### LSI MegaSAS ####
  echo " INFO: Detected LSI MegaSAS controller"

  megacli=/opt/MegaRAID/MegaCli/MegaCli64
  if [[ -x $megacli ]]; then
    voldata=$($megacli -LDInfo -L1 -Aall)
    # Hack just in case we have the data volume set up on logical device 2... RH

    if grep 'Does not Exist' <(echo $voldata); then
      voldata=$($megacli -LDInfo -L2 -Aall)
    fi
 
    # RAID Level
    RAID_LEVEL=$(echo "$voldata"| grep 'RAID Level' | grep -o '[0-9]\+' | head -n 1)

    # Stripe Size
    RAID_STRIPE_SIZE=$(echo "$voldata"| grep 'Stripe\? Size' | grep -o '[0-9]\+')

    # Number of drives
    RAID_DRIVE_COUNT=$(echo "$voldata"| grep 'Number Of Drives' | grep -o '[0-9]\+')

  else
    echo "ERROR: Could not execute MegaCLI, is it installed?"
    exit 1
  fi

else
  #### Fail ####
  echo "ERROR: No controllers detected"
  exit 1


fi

echo " INFO: RAID Level: $RAID_LEVEL"
echo " INFO: RAID Stripe Size: $RAID_STRIPE_SIZE KB"
echo " INFO: RAID Drive Count: $RAID_DRIVE_COUNT Drives"
