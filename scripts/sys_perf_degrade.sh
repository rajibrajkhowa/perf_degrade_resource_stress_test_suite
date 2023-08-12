#! /bin/bash

# This script is for introducing random degrades in system performance by
# introducing CPU load, RAM load and IO load

# How to use the script?

# This script is called by main.sh, however if you want to invoke it in
# standalone mode, then just run ./sys_perf_degrade.sh

# What are the dependencies?

# We need "stress" to be installed in the system to run this script.


# The following line tries to extract the total number of CPUs present in the
# system. This is needed when we run the CPU load code to drive all CPUs
# to 100%

CPU_COUNT=$(lscpu | grep ^"CPU(s)" | awk '{print $2}')

# The following variable assignments are aimed to make it randomized within a given range.
# This makes the script run in a non-interactive limited autonomus manner. An end user is
# free to make changes to the random value ranges of WORKER_COUNT and TIMEOUT.
# The "list" variable indicates the number of degrades. Right now there are three degrades
# hence the values of the list is limited til 3. If further degrades are added, then we can
# expand the list.

list=(1 2 3)

x=$(echo ${list[$RANDOM % ${#list[@]} ]})
 
WORKER_COUNT=$(shuf -i 100-500 -n 1)

TIMEOUT=$(shuf -i 10-120 -n 1)

# The 

if [ $x -eq 1 ]; then
  echo "Hogging the CPU(s)"
  echo
  stress -c $CPU_COUNT -t $TIMEOUT 2>/dev/null
  echo
elif [ $x -eq 2 ]; then
  echo "Hogging the RAM"
  echo
  stress -m $WORKER_COUNT -t $TIMEOUT 2>/dev/null
  echo
elif [ $x -eq 3 ]; then
  echo "Hogging the IO"
  echo
  stress -i $WORKER_COUNT -t $TIMEOUT 2>/dev/null
  echo
else
  echo "Something went wrong"
  exit 1
fi

