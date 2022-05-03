#!/bin/bash

DIR="${0%/*}"
CFG="$DIR/vimrc"
exec /usr/bin/vim -c "source $CFG" $@
