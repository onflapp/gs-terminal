#!/bin/bash

clear

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"

export TERM=gsterm
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"

if ! [ -f "$PREFDIR/htoprc" ];then
  mkdir -p "$PREFDIR" 2> /dev/null
  cp "$DIR/htoprc" "$PREFDIR"
fi

export HTOPRC="$PREFDIR/htoprc"
OPTS=""

if [ "$1" == "user" ];then
  OPTS="$OPTS -u"
fi
if [ "$1" == "apps" ];then
  OPTS="$OPTS -u --filter=.app/"
fi
if [ -n "$2" ];then
  OPTS="$OPTS -F $2"
fi

exec /usr/bin/htop $OPTS
