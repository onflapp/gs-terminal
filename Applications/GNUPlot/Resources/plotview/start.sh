#!/bin/bash

DIR="${0%/*}"
FILE="$2"
XID="$1"

export PAGER="less"
export GNUTERM="x11 window \"$XID\""
export CMD_IN="$FILE"
export CMD_OUT="$FILE-data"
export BASE_DIR="$DIR"

cd "$HOME"
gnuplot "$DIR/gnuplotrc" -
