#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
CF=/tmp/console-$$.cf
MAXLINES="$1"

if [ -n "$2" ];then
  GS="--grep=$2"
fi

function showjournal {
  /usr/bin/journalctl -n $MAXLINES -qeb --no-pager --cursor-file $CF $GS
}

clear
while [ 1 ];do
  showjournal
  sleep 2
done
