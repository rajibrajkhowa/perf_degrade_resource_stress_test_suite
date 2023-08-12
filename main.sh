#! /bin/bash

# This script acts as the interface for the performance degarde and stress testing suite

# How to use the script?

# ./main.sh <number of times we want the degrades to run>

# E.g. ./main.sh 5

# The function sys_perf_degrade() invokes the shell scripts that introduces random performance
# degrade into CPU, RAM and IO

sys_perf_degrade()

{
  ./scripts/sys_perf_degrade.sh
}

# The function net_perf_degrade() invokes the shell scripts that introduces random performance
# degrade like packet drops, delays and errors

net_perf_degrade()

{
  ./scripts/net_perf_degrade.sh
}

# The following code aims at randomizing the selection of the type of performance degrade
# and how many times the degrades would be run

i=$1

while [ $i -ne 0 ]; do

 list=(1 2)

 x=$(echo ${list[$RANDOM % ${#list[@]} ]})
 
 if [ $x -eq 1 ]; then
  echo
  echo "Causing system degrade....."
  echo
  sys_perf_degrade
  
 elif [ $x -eq 2 ]; then
  echo
  echo "Causing network degrade....."
  echo
  net_perf_degrade
  sleep 5
  tc qdisc delete dev ens33 root
  
 else
  echo "Something went wrong"
  exit 1
 fi
 
 i=$(( $i-1 ))
done
 
 