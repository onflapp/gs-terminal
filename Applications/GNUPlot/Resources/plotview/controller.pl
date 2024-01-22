#!/bin/perl

$CI=$ENV{'CMD_IN'};
$CO=$ENV{'CMD_OUT'};
$BASE_DIR=$ENV{'BASE_DIR'};

sub cmd_exec {
  my ($s) = @_;
  print("eval \"$s\"\n");
}

sub cmd_print {
  my ($s) = @_;
  print("print \"$s\"\n");
}

sub cmd_cb {
  my ($s) = @_;
  print("print \"]X;$s\"\n");
}

sub cmd_export {
  my ($s) = @_;
  my $t = "png";

  $t = "postscript" if ($s =~ /\.ps$/);
  $t = "dumb" if ($s =~ /\.txt$/);
  $t = "svg" if ($s =~ /\.svg$/);
  $t = "jpeg" if ($s =~ /\.jpg$/);

  print("set term $t;set output \"$s\";replot; set term GNUTERM\n");
  #cmd_print("export done $s");
}

sub cmd_copy {
  my ($s) = @_;

  my $i = "$CO.png";
  print("set term png;set output \"$i\";replot; set term GNUTERM\n");
  cmd_cb("COPY");
}

sub cmd_load {
  my ($s) = @_;
  #cmd_print("loading from $s");
  open(LIN, $s);
  while(<LIN>) {
    print($_);
  }
  close(LIN);
}

sub cmd_save {
  my ($s) = @_;
  #cmd_print("saving to $s");
  print("save \"| $BASE_DIR/sanitize.pl > $s\"\n");
}

open(IN, $CI);
while(<IN>) {
  chomp();
  $t = substr($_, 0, 2);
  $v = substr($_, 2);
  if ($t eq "L:") {
    cmd_load($v);
  }
  elsif ($t eq "S:") {
    cmd_save($v);
  }
  elsif ($t eq "X:") {
    cmd_export($v);
  }
  elsif ($t eq "C:") {
    cmd_exec($v);
  }
  elsif ($t eq "O:") {
    cmd_copy($v);
  }
  else {
    cmd_print("unknown [$_]");
  }
}
close(IN);
