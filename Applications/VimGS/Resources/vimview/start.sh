#!/bin/bash

DIR="${0%/*}"
CFG="$DIR/vimrc"

export VIMGS_COPY_FILE="$1"
export VIMGS_PASTE_FILE="$2"

shift
shift

exec /usr/bin/vim -c "source $CFG" $@
