#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
LF=/tmp/console-$$.log
WRAPLINES="$1"
MAXLINES="$2"

trap cleanup EXIT

if [ -n "$3" ];then
  GS="--grep=$3"
fi
if [ "$WRAPLINES" -ne "1" ];then
  WL="S"
fi

function cleanup {
  rm $LF 2>/dev/null
}

function waitforready {
  LSZ="0"
  while [ 1 ];do
    sleep 0.1
    NSZ=`stat -c %s $LF`
    if [ "$NSZ" == "$LSZ" ];then
      return
    fi
    echo -n "."
    LSZ="$NSZ"
  done
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
  export SYSTEMD_COLORS=true
  /usr/bin/journalctl -n $MAXLINES -qeb -f --no-pager $GS | highlight >> $LF
}

export LANG=C
PF="]X;F"
PN="]X;N"

touch $LF

readjournal &
waitforready

less -m -Pm$PN -Pw$PF -srQf$WL +GF $LF
