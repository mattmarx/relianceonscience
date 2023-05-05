#!/usr/local/bin/perl

#open(INFILE,"../../wos/txt/wosplpubinfo1955-2017.txt");
open(INFILE,"wos10000filtered.txt");
# space separates patent & ref for the master NPL
# tab separates patent & ref for the yearly slices (and has the year at the end, which could create false positives

$outputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitcode/year_regex_scripts/";

$inputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splityear/";

$date=`date`;
print "$date";

$linect=0;
while (<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 100000)==0) {
	print "At line $linect\n";
    }

    #print $_;
    chop($line);
    if ($line=~/^([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)/) {
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

	$max=$firstpage;
	$min=$vol;
	if ($min>$max) {
	    $temp=$max;
	    $max=$min;
	    $min=$temp;
	}

	if (!($firstauthor eq "[anonymous]")) {
	    $regex= "\tif (/\\W$firstauthor\\W/ & /\\D$min\\D/) { print \"$wosid\t\t$year\t$vol\t$firstpage\t$firstauthor\t\$_\\n\"; }\n";
	    $Output{$year}{$max}.=$regex;
	}
    }
}

foreach $year (sort(keys %Output)) {
    if ($year>2000) { next; } # FIX!!!
    $outputfile="$outputdir"."$year".".pl";
    open(OUTFILE,">$outputfile");
    print OUTFILE "#!/usr/local/bin/perl\n\n";
    foreach $pagevolmax (keys %{ $Output{$year} }) {
	$pagevolfilepath="$inputdir"."$year/"."$pagevolmax";
	# Skip if this file does not exist.  Possibly notate this somewhere.
	if (-e $pagevolfilepath) {
	    print OUTFILE "open(INFILE,\"$pagevolfilepath\");\n";
	    print OUTFILE "while (<INFILE>) {\n";
	    print OUTFILE "$Output{$year}{$pagevolmax}";
	    print OUTFILE "}\n";
	    print OUTFILE "close(OUTFILE);\n\n";
	}
    }
    close(OUTFILE);
}

$date=`date`;
print "$date";
