#!/bin/bash
set -ex

nsamples=10
sleeptime=0

while getopts ":p:n:s:" opt; do
  case ${opt} in
    p)
      echo "Profiling pid $OPTARG."
      pid=$OPTARG
      ;;
    n)
      echo "Doing $OPTARG iterations."
      nsamples=$OPTARG
      ;;
    s)
        echo "Sleep time: $OPTARG"
        sleeptime=$OPTARG
        ;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done


for x in $(seq 1 $nsamples)
  do
    gdb -ex "set pagination 0" -ex "thread apply all bt" -batch -p $pid
    sleep $sleeptime
  done | \
awk '
  BEGIN { s = ""; } 
  /^Thread/ { print s; s = ""; } 
  /^\#/ { if (s != "" ) { s = s "," $4} else { s = $4 } } 
  END { print s }' | \
sort | uniq -c | sort -r -n -k 1,1

