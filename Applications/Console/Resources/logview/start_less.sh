#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
LF="$3"
WRAPLINES="$1"
MAXLINES="$2"

if [ "$WRAPLINES" -ne "1" ];then
  WL="S"
fi

export LANG=C
PF="]X;F"
PN="]X;N"

touch $LF
readjournal &
sleep 0.3
less -m -Pm$PN -Pw$PF -srQf$WL +GF $LF

less -m -Pm$PN "-Pw$PF" -srQf$WL +GF "$LF"
