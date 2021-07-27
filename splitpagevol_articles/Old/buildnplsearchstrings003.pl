#002 combine volume & page separated by nondigit
while (<>) {
 #print $_;
 chop;
 if (/^([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)/) {
 #if (/^([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)$/) {
  $year = $1;
  $year =~ s/\///;
  $wosid = $2;
  $wosid =~ s/\///;
  $vol = $3;
  $vol =~ s/\///;
  $firstpage = $4;
  $firstpage =~ s/\///;
  $firstauthor = $5;
  $firstauthor =~ tr/[A-Z]/[a-z]/;
  $firstauthor =~ s/,.*//;
  $firstauthor =~ s/\///;
 # print "$wosid $year $vol $firstpage $firstauthor\n" if !($firstauthor eq "[anonymous]");
  #print "if (/\W$firstauthor\W/ & /\D$year\D/ & /\D$vol\D+$firstpage\D/) {print \"$wosid\t$1\t$2\n";}\n" if !($firstauthor eq "[anonymous]"); 
  print "if (/\\W$firstauthor\\W/ & /\\D$year\\D/ & /\\D$vol\\D+$firstpage\\D/) {print \"$wosid\t\t$year\t$vol\t$firstpage\t$firstauthor\t\$_\\n\";}\n" if !($firstauthor eq "[anonymous]"); 
 }
}

# space separates patent & ref for the master NPL
# tab separates patent & ref for the yearly slices (and has the year at the end, which could create false positives
