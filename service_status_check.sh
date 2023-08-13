#!/bin/bash

# A helper script to check which service went down after running the
# main.sh script and in case it triggers service outage script

data=${1:-target.txt}

while read x ; do

  y=$(systemctl status $x | grep "Active" | awk '{print $2}')
  echo "$x    $y"
  
done<$data
