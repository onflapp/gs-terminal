#!/bin/bash

DIR="${0%/*}"
PREFDIR="$HOME/Library/Preferences"

exec /usr/bin/journalctl -eb
