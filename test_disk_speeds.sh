#!/bin/bash
f="disk_results.txt"
speed_pat='([0-9]+.[0-9]+) ../s'

for i in {1..1}
do
  echo "----------[Trial $i]----------" >> $f
  vars=()
  # test write speeds
  vars+=("$(dd if=/dev/zero of=/tmp/tempfile bs=1M count=1024 conv=fdatasync,notrunc status=progress 2>&1)")
  vars+=("$(dd if=/tmp/tempfile of=/dev/null bs=1M count=1024 status=progress 2>&1)")
  vars+=("$(dd if=/tmp/tempfile of=/dev/null bs=1M count=1024 status=progress 2>&1)")

  len=${#vars[@]}
  for (( j=0; j<$len; j++ ))
  do
    if [[ "${vars[$j]}" =~ $speed_pat ]]; then 
      echo "${BASH_REMATCH[1]}" >> $f
    fi
  done

  rm /tmp/tempfile
done
