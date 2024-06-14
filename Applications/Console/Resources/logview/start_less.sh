#!/usr/bin/env bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
LF=/tmp/console-$$.log
WRAPLINES="$1"
MAXLINES="$2"
MYPID="$$"
MYLOG="$4"
GREP="$3"

trap cleanup EXIT

if [ "$WRAPLINES" -ne "1" ];then
  WL="S"
fi

function cleanup {
  rm $LF 2>/dev/null
}

function readjournal {
  ## ignore SIGINT, this will be handled by less
  trap '' SIGINT

  if [ -n "$GREP" ];then
    tail --pid $MYPID -f -n $MAXLINES "$MYLOG" | grep "$GREP" >> $LF
  else
    tail --pid $MYPID -f -n $MAXLINES "$MYLOG" >> $LF
  fi
}

export LANG=C
PF="]X;F"
PN="]X;N"

touch $LF
readjournal &
sleep 0.3
less -m --follow-name -Pm$PN -Pw$PF -srQf$WL +GF $LF
