#!/bin/perl

$BASE_DIR=$ENV{'BASE_DIR'};

while(<STDIN>) {
  next if (/^GNUTERM =/);
  next if (/^E =/);
  next if (/^#/);

  print(STDOUT $_);
}
