#!/usr/bin/env bash

clear

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
PREFFILE="$PREFDIR/htoprc2"

export TERM=gsterm-1000
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"

if ! [ -f "$PREFFILE" ];then
  mkdir -p "$PREFDIR" 2> /dev/null
  cp "$DIR/htoprc" "$PREFFILE"
fi

export HTOPRC="$PREFFILE"
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

exec htop $OPTS
