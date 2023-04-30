#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
LF=/tmp/console-$$.log
WRAPLINES="$1"
MAXLINES="$2"
MYPID="$$"

trap cleanup EXIT

if [ -n "$3" ];then
  GREP="$3"
fi
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
    tail --pid $MYPID -f -n $MAXLINES "$GS_DESKTOP_LOG" | grep "$GREP" >> $LF
  else
    tail --pid $MYPID -f -n $MAXLINES "$GS_DESKTOP_LOG" >> $LF
  fi
}

export LANG=C

touch $LF
readjournal &
sleep 0.3
less -sRQf$WL +GF $LF
