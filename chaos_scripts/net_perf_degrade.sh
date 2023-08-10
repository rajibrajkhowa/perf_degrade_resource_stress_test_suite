#! /bin/bash


list=(1 2)

x=$(echo ${list[$RANDOM % ${#list[@]} ]})
 
WAIT_PERIOD=$(shuf -i 60-120 -n 1)

DELAY=$(shuf -i 60-300 -n 1)

LOSS=$(shuf -i 5-10 -n 1)

if [ $x -eq 1 ]; then
  echo "Introducing packet loss of" "${LOSS}""%" "for" "${WAIT_PERIOD}""sec"
  echo
  tc qdisc replace dev ens33 root netem loss ${LOSS}% 25%
  sleep $WAIT_PERIOD
  tc qdisc delete dev ens33 root
  echo
elif [ $x -eq 2 ]; then
  echo "Introducing delay of" "${DELAY}""ms" "for" "${WAIT_PERIOD}""sec"
  echo
  tc qdisc add dev ens33 root netem delay ${DELAY}ms 10ms distribution normal
  sleep $WAIT_PERIOD
  tc qdisc delete dev ens33 root
  echo
else
  echo "Something went wrong"
  exit 1
fi



