#!/bin/bash
 
# This script is for introducing random outages of services
# by matching a reference target list of services with list
# of services running in the system

# How to use the script?

# This script is called by main.sh, however if you want to invoke it in
# standalone mode, then just run ./service_outage.sh target.txt


# Create a file with list of services that are running in the system

systemctl --type=service | awk '{print $1}' > temp.txt

grep -e ".service" temp.txt > service_list.txt

rm temp.txt


# Create an emplty list of target services that needs to be randomly 
# brought down

TARGET_LIST=$()

# Store the list of target services to be brought down in a text file
# and read it line by line and store it in the list TARGET_LIST

n=$(cat target.txt | wc -l)


data=${1:-target.txt}

while read x ; do

  if [ $n -ne 0 ]; then
     TARGET_LIST+=( $x )
     n=$(( $n-1 ))
  fi

done<$data


# Randomly pick a target from the TARGET_LIST

y=$(echo ${TARGET_LIST[$RANDOM % ${#TARGET_LIST[@]} ]})


# Search the target string in the service list containing running services
# in the system and store it in a variable

z=$(grep $y service_list.txt)

# If the service is found then stop it

if [ -z "$z" ]; then
   
   echo "Either service is inactive or not present in the system"
   
else
   systemctl stop $z
   echo "Stopped some service. Guess what?"
fi

rm service_list.txt
