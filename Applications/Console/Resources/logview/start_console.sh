#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
LF=/tmp/console-$$.log
MAXLINES="$1"
WRAPLINES="$2"

trap cleanup EXIT

if [ -n "$3" ];then
  GS="--grep=$3"
fi
if [ "$2" -ne "1" ];then
  WL="S"
fi

function cleanup {
  rm $LF 2>/dev/null
}

function highlight {
  while read -r line ;do
    #if [[ "$line" =~ ^(.*?):(.*?)$ ]];then
    #printf '%s::\n' ${BASH_REMATCH[1]}
    echo $line
  done
}

function readjournal {
  export SYSTEMD_LOG_COLOR="1"
  export SYSTEMD_COLORS="16"
  /usr/bin/journalctl -n $MAXLINES -qeb -f --no-pager $GS | highlight >> $LF
}

export LANG=C

touch $LF
readjournal &
sleep 0.3
less -sRqf$WL +GF $LF
