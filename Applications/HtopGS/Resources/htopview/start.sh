#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"
export TERM=screen

if ! [ -f "$PREFDIR/htoprc" ];then
  mkdir -p "$PREFDIR" 2> /dev/null
  cp "$DIR/htoprc" "$PREFDIR"
fi

export HTOPRC="$PREFDIR/htoprc"
exec /usr/bin/htop
