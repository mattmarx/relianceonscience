#!/usr/local/bin/perl
 while (<>) {
 chomp;
 if (/^(\S+)\s+(\S+)\s+(.*)$/) {
  $patent = $1;
  $year = $2;
  $line = $3;
  $line =~s/OTHER REFERENCES//i;
  @npls = split /.................................../, $line;
  print "\n\n__US$patent\n$line\n";
 }
}

