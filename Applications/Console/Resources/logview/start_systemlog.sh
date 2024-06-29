#!/usr/bin/env bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
LF=/tmp/console-$$.log
WRAPLINES="$1"
MAXLINES="$2"

trap cleanup EXIT

if [ -n "$3" ];then
  GS="--grep=$3"
  GREP="$3"
fi
if ! [ "$WRAPLINES" = "1" ];then
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
    if [ "$NSZ" = "$LSZ" ];then
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

function readjournal_systemd {
  export SYSTEMD_LOG_COLOR="1"
  export SYSTEMD_COLORS="16"
  export SYSTEMD_COLORS=true
  journalctl -n $MAXLINES -qeb -f --no-pager $GS | highlight >> $LF
}

function readjournal_messages {
  ## ignore SIGINT, this will be handled by less
  trap '' SIGINT

  if [ -n "$GREP" ];then
    tail --pid $MYPID -f -n $MAXLINES /var/log/messages | grep "$GREP" >> $LF
  else
    tail --pid $MYPID -f -n $MAXLINES /var/log/messages >> $LF
  fi
}

export LANG=C
PF="."
PN=":"

touch $LF

if command -V journalctl >/dev/null 2>&1 ;then
  readjournal_systemd &
  waitforready

  less -m --follow-name -Pm$PN -Pw$PF -srQf$WL +GF $LF
else
  readjournal_messages &
  sleep 0.3

  less -m --follow-name -Pm$PN -Pw$PF -srQf$WL +GF $LF
fi
