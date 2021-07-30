while (<>) {
chop;
 $patnum = $1 if (/^(\d+)/);
 $npl = $1 if (/^\d+\t\W+(.*)$/);
 #print ">$patnum<\t>$npl<\n";
 #print "$_\n";
 $npl=~s/^\W+//;
 $npl=~s/\"\"/\"/g;
 if ($npl=~m/\"([^\"]{5,100})\"/) {
   $title = $1;
   $title=~s/\W/ /g;
   $title=~s/  / /g;
   print "$title\t$patnum\t$npl\n";   
   #print "TITLE=$title\n";
   
 } else {
    print ".";
   #print STDERR "no title\n";
 }
}
