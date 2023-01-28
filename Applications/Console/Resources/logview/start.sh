#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
CF=/tmp/console-$$.cf
MAXLINES="$1"

trap cleanup EXIT

if [ -n "$2" ];then
  GS="--grep=$2"
fi

function cleanup {
  rm $CF 2>/dev/null
}

function readjournal {
  while [ 1 ];do
    /usr/bin/journalctl -n $MAXLINES -qeb --no-pager --cursor-file $CF $GS
    sleep 2
  done
}

clear
readjournal
