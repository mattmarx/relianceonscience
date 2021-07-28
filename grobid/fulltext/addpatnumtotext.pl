#!/usr/local/bin/perl 
#$patent = "";
while (<>) {
 #print "\n";
#print;
 chomp;
 $line = $_;
 if ($line =~ /^__US\-?([0-9a-zA-Z]+)/) {
  $posspat = $1;
  print "__US" . $patent . "\t" . $lines . "\n" if (($lines=~/\w/) && $lines=~/.{10,}/ && !($patent eq ""));
  $patent =  $posspat;
  $patent =~ s/^0+//;
  $lines = "";
  #print "\n";
 }
 else {
  $line =~ s/^__description//;
  if (length($lines)<50000) {
   $lines = $lines . " " . $line;
  } else {
   #print "SPLITTING PATENT TEXT\n";
   print "__US" . $patent . "\t" . $lines . "\n" if (($lines=~/\w/) && $lines=~/.{10,}/ && !($patent eq ""));
   $lines = $line;
  #print "\n";
  }
 }
}

