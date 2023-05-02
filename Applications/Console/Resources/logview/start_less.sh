#!/bin/bash -x

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
LF="$3"
WRAPLINES="$1"
MAXLINES="$2"

if [ "$WRAPLINES" -ne "1" ];then
  WL="S"
fi

PF="]X;F"
PN="]X;N"

less m -Pm$PN -Pw$PF -sQf$WL +GF "$LF"
