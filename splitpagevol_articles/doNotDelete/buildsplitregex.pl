#!/usr/local/bin/perl

open(INFILE,"wosplpubinfo1955-2017_filtered.txt");
# space separates patent & ref for the master NPL
# tab separates patent & ref for the yearly slices (and has the year at the end, which could create false positives

$maxpagevol=100000;

$outputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitcode/year_regex_scripts/";

$inputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splityear/";

$date=`date`;
print "$date";

chdir("/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitcode");

$linect=0;
while (<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 100000)==0) {
	print "At line $linect\n";
    }

    #print $_;
    chop($line);
    if ($line=~/^([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)/) {
	$year = $1;
	$wosid = $2;
	$vol = $3;
	$firstpage = $4;
	$firstauthor = $5;
	$title=$6;
	$year =~ s/\///;
	$wosid =~ s/\///;
	$vol =~ s/\///;
	$firstpage =~ s/\///;
	$firstauthor =~ tr/[A-Z]/[a-z]/;
	$firstauthor =~ s/,.*//;
	$firstauthor =~ s/\///;
        #$title =~ s/\"//g;
	$title=~s/[^a-zA-Z0-9-,'.(): ]//g;
	#$title =~ s/[^a-zA-Z0-9]//g;
#print STDERR "title = >$title<\n";

	$max=$firstpage;
	$min=$vol;
	# Use highest value unless highest value is over the speicified limit (100,000 as of 6/27/18)
	if (($min>$max)||($min && ($max>$maxpagevol))) {
	    $temp=$max;
	    $max=$min;
	    $min=$temp;
	}

	if (!(($firstauthor eq "")||($firstauthor eq "[anonymous]")||($year<1900)||($year>2017)||($vol eq "")||($firstpage eq ""))) {
         $regex= "\tif (/\\W$firstauthor\\W/ && /\\D$vol\\D+$firstpage\\D/) { print \"$wosid\t\t$year\t$vol\t$firstpage\t$firstauthor\t$title\t\$_\"; }\n";	  
# used to use  minmax scheme, but this led to false positives. now search for both volume and firstpage
#       if ($min) {
#	$regex= "\tif (/\\W$firstauthor\\W/ & /\\D$min\\D/) { print \"$wosid\t\t$year\t$vol\t$firstpage\t$firstauthor\t\$_\"; }\n";
#	    }
#	    else {
#		$regex= "\tif (/\\W$firstauthor\\W/) { print \"$wosid\t\t$year\t$vol\t$firstpage\t$firstauthor\t\$_\"; }\n";
#	    }
	    $Output{$year}{$max}.=$regex;
	}
    }

}

print "\n";

foreach $year (sort(keys %Output)) {
    print "Year is $year\n";
    $outputfile="$outputdir"."year"."$year".".pl";
    open(OUTFILE,">$outputfile");
    print OUTFILE "#!/share/pkg/perl/5.24.0/install/bin/perl\n\n";
    foreach $pagevolmax (keys %{ $Output{$year} }) {
	$pagevolfilepath="$inputdir"."$year/"."$pagevolmax";
	# Skip if this file does not exist.  Possibly notate this somewhere.
	if (-e $pagevolfilepath) {
	    print OUTFILE "open(INFILE,\"$pagevolfilepath\");\n";
	    print OUTFILE "while (<INFILE>) {\n";
	    print OUTFILE "$Output{$year}{$pagevolmax}";
	    print OUTFILE "}\n";
	    print OUTFILE "close(INFILE);\n\n";
	}
    }
    close(OUTFILE);
}

$date=`date`;
print "$date";
