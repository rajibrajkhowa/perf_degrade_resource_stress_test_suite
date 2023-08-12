#! /bin/bash

# This script is for introducing random degrades in network performance by
# introducing delays, packet drops and packet corruptions

# How to use the script?

# This script is called by main.sh, however if you want to invoke it in
# standalone mode, then just run ./net_perf_degrade.sh

# What are the dependencies?

# We need "nmcli" and "iproute2" to be installed in the system to run this script.

# The following line tries to filter out the interface on which the degardes would be run.
# Right now the following line picks up the first ethernet port that is listed by nmcli

IFACE=$(nmcli device status | awk '{print $1}' | grep  '[eth|ens|enp]' | head -1)

# The following variable assignments are aimed to make it randomized within a given range.
# This makes the script run in a non-interactive limited autonomus manner. An end user is
# free to make changes to the random value ranges of WAIT_PERIOD, DELAY, LOSS and CORRUPT.
# The "list" variable indicates the number of degrades. Right now there are three degrades
# hence the values of the list is limited till 3. If further degrades are added, then we can
# expand the list.

list=(1 2 3)

x=$(echo ${list[$RANDOM % ${#list[@]} ]})
 
WAIT_PERIOD=$(shuf -i 60-120 -n 1)

DELAY=$(shuf -i 60-300 -n 1)

LOSS=$(shuf -i 5-10 -n 1)

CORRUPT=$(shuf -i 5-10 -n 1)

# The following code intorduces the various network performance degrades based on the 
# options that are randomly generated

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
