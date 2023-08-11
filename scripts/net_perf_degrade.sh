#! /bin/bash

IFACE=$(nmcli device status | awk '{print $1}' | grep  '[eth|ens|enp]' | head -1)

list=(1 2 3)

x=$(echo ${list[$RANDOM % ${#list[@]} ]})
 
WAIT_PERIOD=$(shuf -i 60-120 -n 1)

DELAY=$(shuf -i 60-300 -n 1)

LOSS=$(shuf -i 5-10 -n 1)

CORRUPT=(shuf -i 5-10 -n 1)

if [ $x -eq 1 ]; then
  echo "Introducing packet loss of" "${LOSS}""%" "for" "${WAIT_PERIOD}""sec"
  echo
  tc qdisc replace dev $IFACE root netem loss ${LOSS}%
  sleep $WAIT_PERIOD
  tc qdisc delete dev $IFACE root
  echo
elif [ $x -eq 2 ]; then
  echo "Introducing delay of" "${DELAY}""ms" "for" "${WAIT_PERIOD}""sec"
  echo
  tc qdisc add dev $IFACE root netem delay ${DELAY}ms 10ms distribution normal
  sleep $WAIT_PERIOD
  tc qdisc delete dev $IFACE root
  echo
elif [ $x -eq 3 ]; then
  echo "Introducing packet corruption of" "${CORRUPT}""%" "for" "${WAIT_PERIOD}""sec"
  echo
  tc qdisc replace dev $IFACE root netem corrupt ${CORRUPT}%
  sleep $WAIT_PERIOD
  tc qdisc delete dev $IFACE root
  echo
else
  echo "Something went wrong"
  exit 1
fi
