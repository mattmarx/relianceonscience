#!/usr/local/bin/perl

$inputyear="";
$file=0;
if ($ARGV[0]=~/^wos$/i) {
    $inputfilesbasepath="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/wos/wosbyyear/wos_";
    $inputyear=$ARGV[1];
    $sourcefilecode="wos";

    $inputfile="$inputfilesbasepath"."$inputyear".".tsv";

    if (!$inputyear) {
	die("Usage: buildtitleregex_byyear_front.pl mag YEAR|wos YEAR|filename_or_fullpath_of_file\n");
    }
}
elsif ($ARGV[0]=~/^mag$/i) {
    $inputfilesbasepath="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/mag/magbyyear/mag_";
    $inputyear=$ARGV[1];
    $sourcefilecode="mag";

    $inputfile="$inputfilesbasepath"."$inputyear".".tsv";

    if (!$inputyear) {
	die("Usage: buildsplitregex_byyear_front.pl mag YEAR|wos YEAR|filename_or_fullpath_of_file\n");
    }
}
else {
    $inputfile=$ARGV[0];
    $sourcefilecode="file";
    $file=1;
    
    if (!(-e $inputfile)) {
	die("Usage: buildsplitregex_byyear.pl mag|wos|filename_or_fullpath_of_file\n");
    }
}

print "Using source directory/file: $inputfile  Sourcecode: $sourcefilecode\n\n";

open(INFILE,$inputfile)||die("Can't open input file $inputfile");
# space separates patent & ref for the master NPL
# tab separates patent & ref for the yearly slices (and has the year at the end, which could create false positives

$maxpagevolissue=100000;

$outputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitpagevol_articles/year_regex_scripts_front_" . "$sourcefilecode". "/";;

$inputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitpagevol_patent/front/";

$date=`date`;
print "$date";

chdir("/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitpagevol_articles");

$linect=0;
while (<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 100000)==0) {
	print "At line $linect\n";
    }


    #print $_;
    chop($line);
    if ($line=~/^([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)/) {
	$year = $1;
	$wosid = $2;
	$vol = $3;
 	$issue = $4;
	$firstpage = $5;
	$lastpage = $6;
	$firstauthor = $7;
	$title=$8;
	$journal=$9; 

	$year =~ s/\///;
	$wosid =~ s/\///;
	$vol =~ s/\///;
	$firstpage =~ s/\///;
	$lastpage =~ s/\///;
	$issue =~ s/\///;
	$vol =~ s/\?//;
	$firstpage =~ s/\?//;
	$lastpage =~ s/\?//;
	$issue =~ s/\?//;
	$vol =~ s/\(//;
	$firstpage =~ s/\(//;
	$lastpage =~ s/\(//;
	$issue =~ s/\(//;
	$vol =~ s/\)//;
	$firstpage =~ s/\)//;
	$lastpage =~ s/\)//;
	$issue =~ s/\)//;
	$title=~s/[^a-zA-Z0-9-,'.(): ]//g;
	$title_print=$title;
	$journal=~s/"//g;

	# If a single ? in firstauthor name, treat it as a wildcard (.) character.  This is being 
	# done in a two phase process.  Remove additional ? and most other non-alphanumeric 
	# characters.
	$firstauthor=~s/\?/TEMPORARY/;
	$firstauthor=~s/[^a-zA-z0-9-_,' ]//g; # Remove problematic characters in author name
	$firstauthor=~s/\[//g; # Remove problematic characters in author name
	$firstauthor=~s/\]//g; # Remove problematic characters in author name
	$firstauthor=~s/TEMPORARY/./;
	$firstauthor_lastname=$firstauthor;
	$firstauthor_lastname =~ tr/[A-Z]/[a-z]/;
	$firstauthor_lastname =~ s/,.*//;
	$firstauthor_lastname =~ s/\///;

	if (($file==0)&&($year!=$inputyear)) { 
	    print "ERROR: Mismatch of inputyear $inputyear and line: \n$line\n"; 
	}

	# Skip items with No author, "[anonymous]" author, before 1800, or after 2019
	# MMADD change this to 1799 to accommodate the no-year NPs
	if (($firstauthor_lastname eq "")||($firstauthor_lastname eq "[anonymous]")||($year<1799)||($year>2019)) { next; }

	$matchnumber=$firstpage;
	if (!$matchnumber) { $matchnumber=$vol; }
	
	# Skip authors with no alphanumerics
	if ($firstauthor=~/\w/) {
	    if ($matchnumber) {
		if (length($firstauthor_lastname)>=4) {
		    $vowels_lastname=$firstauthor_lastname;
		    $vowels_lastname=~s/[aeiou]/\[aeiou\]/g;
		    $regex= "\tif ((/\[\^a\-zA\-Z0\-9\_\-\]\\w\?$firstauthor_lastname\[\^a\-zA\-Z0\-9\_\-\]/)||(/\[\^a\-zA\-Z0\-9\_\-\]$firstauthor_lastname\\w\?\[\^a\-zA\-Z0\-9\_\-\]/)||(/\[\^a\-zA\-Z0\-9\_\-\]$vowels_lastname\[\^a\-zA\-Z0\-9\_\-\]/)) { print \"$wosid\t$year\t$vol\t$issue\t$firstpage\t$lastpage\t$firstauthor\t$title_print\t$journal\t\$_\"; }\n";
		}
		else {
		    $regex= "\tif (/\[\^a\-zA\-Z0\-9\_\-\]$firstauthor_lastname\[\^a\-zA\-Z0\-9\_\-\]/) { print \"$wosid\t$year\t$vol\t$issue\t$firstpage\t$lastpage\t$firstauthor\t$title_print\t$journal\t\$_\"; }\n";
		}
		$Output{$year}{$matchnumber}.=$regex;
		$Output{$year+1}{$matchnumber}.=$regex;
		if ($year!=1800) {
		    $Output{$year-1}{$matchnumber}.=$regex;
		}
	    }
	}
    }
    else {
#	print "No format match found for line $linect - $line\n";
    }
}

print "\n";

if ($file==0) {
    $year=$inputyear;
    print "Year is $year\n";
    $outputfile="$outputdir"."year"."$year".".pl";
    open(OUTFILE,">$outputfile");

    # Perl line 
    print OUTFILE "#!/share/pkg/perl/5.24.0/install/bin/perl\n\n";

    foreach $year (sort(keys %Output)) {
	foreach $matchnumber (keys %{ $Output{$year} }) {
	    $firstchar=substr($matchnumber,0,1);
	    $pagevolfilepath="$inputdir"."$year/"."$firstchar/"."$matchnumber";
	    # Skip if this file does not exist.  Possibly notate this somewhere.
	    print "Matchnumber $matchnumber\n\t$firstchar\t$pagevolfilepath\n";
	    if (-e $pagevolfilepath) {
		print OUTFILE "open(INFILE,\"$pagevolfilepath\");\n";
		print OUTFILE "while (<INFILE>) {\n";
		print OUTFILE "$Output{$year}{$matchnumber}";
		print OUTFILE "}\n";
		print OUTFILE "close(INFILE);\n\n";
	    }
	}
    }
    close(OUTFILE);
    `chmod 775 $outputfile`;
}
else {
    foreach $year (sort(keys %Output)) {
	print "Year is $year\n";
	$outputfile="$outputdir"."year"."$year".".pl";
	open(OUTFILE,">$outputfile");
	print OUTFILE "#!/share/pkg/perl/5.24.0/install/bin/perl\n\n";
	foreach $matchnumber (keys %{ $Output{$year} }) {
	    $firstchar=substr($matchnumber,0,1);
	    $pagevolfilepath="$inputdir"."$year/"."$firstchar/"."$matchnumber";
	    # Skip if this file does not exist.  Possibly notate this somewhere.
	    if (-e $pagevolfilepath) {
		print OUTFILE "open(INFILE,\"$pagevolfilepath\");\n";
		print OUTFILE "while (<INFILE>) {\n";
		print OUTFILE "$Output{$year}{$matchnumber}";
		print OUTFILE "}\n";
		print OUTFILE "close(INFILE);\n\n";
	    }
	}
	close(OUTFILE);
	`chmod 775 $outputfile`;
    }
}

$date=`date`;
print "$date";
