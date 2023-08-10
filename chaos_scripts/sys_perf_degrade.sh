#! /bin/bash


CPU_COUNT=$(lscpu | grep ^"CPU(s)" | awk '{print $2}')

list=(1 2 3)

x=$(echo ${list[$RANDOM % ${#list[@]} ]})
 
WORKER_COUNT=$(shuf -i 100-500 -n 1)

TIMEOUT=$(shuf -i 10-120 -n 1)

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

