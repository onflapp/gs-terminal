#!/bin/bash

DIR="${0%/*}"
CFG="$DIR/init.el"

export EMACSGS_COPY_FILE="$1"
export EMACSGS_PASTE_FILE="$2"

shift
shift

FILE="$1"
if [[ "$FILE" =~ ^(.*):([0-9]+)$ ]];then
  FILE=${BASH_REMATCH[1]}
  LINE=${BASH_REMATCH[2]}
  exec /usr/bin/emacs -nw -l "$CFG" "+$LINE" "$FILE"
else
  exec /usr/bin/emacs -nw -l "$CFG" $@
fi
