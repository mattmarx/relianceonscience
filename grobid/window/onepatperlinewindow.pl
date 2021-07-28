#!/usr/local/bin/perl

$latspat = "";
$fencepost = 1;

while (<>) {
 if (/(.*)\t(.*)/) {
  $patent = $1;
  $line = $2;
  #print "\n\nPAT:$patent\tLINE:$line\n";
  $lines = $lines . " " . $line;
  #print "PAT:$patent\tLINES:$lines\n";
  if (!($patent eq $lastpat)) {
	  if ($fencepost==0) {
		  #print "WHY...\n";
            print "$patent\t$lines\n";
          } else {
	    $fencepost = 0;
	    #print "NOT YET\n";
          } 
   } else {

   #print "\n";
   $lines = "";
  }
  $lastpat = $patent;
 }
}
print "$patent\t$lines\n";
