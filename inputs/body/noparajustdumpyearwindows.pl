#!/usr/local/bin/perl 
$patent = "";
#@npls = ();
$prewindowsize = 250;
$postwindowsize = 250;
$stepdebug = 0;

while (<>) {
 chop;
 if (/(^[^\t]\d+)\t([^\t]+)/) {
  $patent = $1;
  print "patent $patent\n" if $stepdebug==1;
  $para = $2;
  @yearpos = ();
  @chars = ();
  @chars = split(//,$para); 
  for my $i (0 .. $#chars) {
   if (
       #it's a year
       (
        #20[012]
        ($chars[$i]=~/2/ && $chars[$i+1]=~/0/ && $chars[$i+2]=~/[012]/ && $chars[$i+3]=~/\d/)
        ||
        #18xx, 19xx
        ($chars[$i]=~/1/ && $chars[$i+1]=~/[89]/ && $chars[$i+2]=~/\d/ && $chars[$i+3]=~/\d/)
       )
       && 
       # not preceded or followed by digit or dash (as in page range)
       ($chars[$i-1]=~/[^\d\w\-\/]/ && $chars[$i+4]=~/[^\d\w\-\/]/)
      ) {
    print "adding yearpos $i\n" if $stepdebug==1;
    push @yearpos, $i;
   }
  }
  print "There are $#yearpos + 1 in the string\n" if $stepdebug==1;
  if ($#yearpos>=0) {
   foreach my $yearmarker (@yearpos) {
    $startpos = $yearmarker-$prewindowsize;
    $startpos = 0 if $startpos<0;
    $stoppos = $yearmarker+$postwindowsize;
    $stoppos = $#chars if $stoppos>$#chars;
    $length = $stoppos - $startpos;
    $year = substr $para, $yearmarker, 4;
    $extract = substr $para, $startpos, $length;
    $matchlenshort= $yearmarker - 7;
    #$extract =~ s/^(.{$yearmarker}$year.*)$year.*/$1/;
    #$extract =~ s/^(.{$yearmarker}$year.*)$year.*/$1/;
    #$extract =~ s/^(.{$matchlenshort}$year.*)$year.*/$1/;
    #$extract =~ s/^(.{$matchlenshort}$year.*)$year.*/$1/;
    #$extract =~ s/^(.{$yearmarker}$year.*)$year.*/$1/;
    print "MIDFILT: $extract\n" if $stepdebug==1;
    #$extract =~ s/^(.*$year)(.*$year.*)$/$2/;
    print "POSTFILT: $extract\n" if $stepdebug==1;

    if ($startpos>0) {
	$prevchar=substr($para, $startpos-1, 1);
	if ($prevchar=~/\w/) { $extract=~s/^(\S+)/" " x length($1)/e }
    }
    if ($stoppos<$#chars) {
	$postchar=substr($para, $startpos+$length, 1);
	if ($postchar=~/\w/) { $extract=~s/(\S+)$/" " x length($1)/e }
    }

    print "__US$patent\t$year\t$startpos\t$extract\n";
   }
  } else {
   print "NOT! >$patent<\n" if $stepdebug==1;
  }
 }
}
