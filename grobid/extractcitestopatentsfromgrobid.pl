#!/usr/local/bin/perl
$debug = 0;

while (<>) {
 #print;
 chop;

 #if it's a new patent, change the patent # and blank out everything
 #if (/^__US([A-Z]*\d+)/ || /^([A-Z]*\d+)/) {
 if ($new_patent_next_line==1 && /^(\S+)/) {
 #print "\n\nTHIS LINE GOTTA BE A PATENT!\n$_\n";
 ##if (/^(__US[A-Z]*\d+)/) {
  #print "NEW PATENT $1\n";
  print STDERR "\n\nnew patent\n" if $debug==1;
  $patent = $1;
  $cited_patent = "";
  $inarticle = 0;
  $new_patent_next_line = 0;
 }
 if (/^<div id=.*>/) {
  print "NEXT LINE WILL BE A PATENT!\n$_\n" if $debug==1;
  $new_patent_next_line = 1;
 }
 # if a new listbibl, we're in a new article. 
 if (/<biblStruct/) {
  $inarticle = 1;
  $cited_patent = "";
  print "\nnew cite\n" if $debug==1;
  #print STDERR "\nnew cite\n" if $debug==1;
  #if (/type=\"patent\"/) {
  if (/type.*patent/) {
   #print STDERR "new patent cite\n" if $debug==1;
   print STDERR "new patent cite\n" if $debug==1;
   if (/subtype=\"original\">(\d+)</) {
    $cited_patnum = $1;
    print STDERR "-->$cited_patnum\n" if $debug==1;
   }
   if (/national\">(\w+)</) {
    $office = $1;
   }
   if (/regional\">(\w+)</) {
    $office = $1;
   }
   $patent_num = $patent;
   $patent_num =~ s/__US//;
   $cited_patent = $office . "-" . $cited_patnum;
   if (!($patent_num eq $cited_patnum)) {
    print "$patent\t$cited_patent\n";
   } else {
    print STDERR "not printing, $patent = $cited_patent\n" if $debug==1;
   }
  }
 }
 # at end of the record, print any match we have
 if (/<\/TEI>/) {
  print STDERR "end of record\n" if $debug==1;
  # if we were in an article, print out what we had
  #print "$patent\t$cited_patent\n";
  $inarticle = 0;
  $cited_patent = "";
 }
}
