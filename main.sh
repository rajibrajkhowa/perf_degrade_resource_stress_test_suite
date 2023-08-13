#! /bin/bash

# This script acts as the interface for the performance degarde and stress testing suite

# How to use the script?

# ./main.sh <number of times we want the degrades to run>

# E.g. ./main.sh 5

# The function sys_perf_degrade() invokes the shell scripts that introduces random performance
# degrade into CPU, RAM and IO

sys_perf_degrade()

{
  ./sys_perf_degrade.sh
}

# The function net_perf_degrade() invokes the shell scripts that introduces random performance
# degrade like packet drops, delays and errors

net_perf_degrade()

{
  ./net_perf_degrade.sh
}

# The function service_outage() brings down a service randomly by referencing a target list
# available in "target.txt" file. If the services configured in the system matches with an
# entry in "target.txt" file, then that service is stopped or brought down. This script will
# simulate a random service outage scenario.

service_outage()

{
   ./service_outage.sh
}

# The following code aims at randomizing the selection of the type of performance degrade
# and how many times the degrades would be run. Variable "i" takes a command line argument
# to indicate the number of runs. The variable "list" indicates the number of degrades. 
# Right now there are two degrades - system degrades and network degrades in our suite,
# hence the values of the list is limited till 3. If further degrades are added, then we can
# expand the list.

i=$1

if [ -z $1 ]; then
  
  echo "The number of runs are not mentioned"
  exit 1

else
   while [ $i -ne 0 ]; do

   list=(1 2 3)

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

  elif [ $x -eq 3 ]; then
   echo
   echo "Causing service outage....."
   echo
   service_outage
  
  else
   echo "Something went wrong"
   exit 2
  fi
 
  i=$(( $i-1 ))
 done
fi
