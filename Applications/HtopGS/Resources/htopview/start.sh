#!/bin/bash

DIR="${0%/*}"
export TERM=screen

exec /usr/bin/htop
