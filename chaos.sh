#! /bin/bash

sys_perf_degrade()

{
  ./chaos_scripts/sys_perf_degrade.sh
}

net_perf_degrade()

{
  ./chaos_scripts/net_perf_degrade.sh
}

i=5

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
 
 