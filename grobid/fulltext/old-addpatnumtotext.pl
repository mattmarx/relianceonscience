#!/usr/local/bin/perl 
#$patent = "";
while (<>) {
 print;
 chomp;
 $line = $_;
 if (/^__US\-?([0-9a-zA-Z]+)/) {
  $patent =  $1;
  $patent =~ s/^0+//;
 }
 else {
  $line =~ s/^__description//;
  print "__US" . $patent . "\t" . $line . "\n" if (($line=~/\w/) && $line=~/.{10,}/);
 }
}

