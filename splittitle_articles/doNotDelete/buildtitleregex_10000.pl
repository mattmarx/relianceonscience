#!/usr/local/bin/perl

$minlength=6;
$maxlength=20;

open(INFILE,"wosplpubinfo1955-2017_filtered.txt");
open(INFILE,"wos10000_filtered.txt");
# space separates patent & ref for the master NPL
# tab separates patent & ref for the yearly slices (and has the year at the end, which could create false positives

open(SKIPFILE,"/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitword/skipwords")||die("Couldn't open skipwords file.\n");
while(<SKIPFILE>) {
    $word=$_;
    $word=~s/\s+//g;
    $SkipWord{$word}=1;
}
close(SKIPFILE);

$outputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splittitle/year_regex_scripts/";

$inputdir="/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitword/";

$date=`date`;
print "$date";

chdir("/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splittitle");

open(TEMPLATE,"template_perl");
while(<TEMPLATE>) {
    $perl_template.=$_;
}
close(TEMPLATE);

$linect=0;
while (<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 100000)==0) {
	print "At line $linect\n";
    }

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
	$title=~s/"//g;

	if (($firstauthor eq "[anonymous]")||($year<1955)||($year>2017)) { next; }

	$modtitle=$title;
	$modtitle=lc($title);
	$modtitle=~s/^the //;
	$modtitle=~s/^a //;
	$modtitle=~s/^an //;
	$modtitle=~s/[^a-zA-Z0-9]*//g;

	$mytitle=lc($title);
	$mytitle=~s/\"/ /;
	$mytitle=~s/-/ /;
	$mytitle=~s/:/ /;

	# Find longest good word in title.
	@words="";
	@words=split(/\s+/,$mytitle);
	$prevword="";
	$longest=0;
	$myword="";
	foreach $word (sort(@words)) {
	    $word=~s/[^a-zA-Z]*//g;

	    # Avoid duplicates
	    if ($word eq $prevword) { next; }

	    # Skip short and long words
	    if ((length($word)<$minlength)||(length($word)>$maxlength)) { next; }

	    # Avoid very common words
	    if ($SkipWord{$word}) { next; }

	    if (length($word)>$longest) {
		$longest=length($word);
		$myword=$word;
	    }

	    $prevword=$word;
	}

#	print "$year $myword\n";

	if ($myword) {
	    $output="$wosid\t\t$year\t$vol\t$firstpage\t$firstauthor\t$title\t";
	    $regex= "\tif (/\\W$firstauthor\\W/) { &fullcompare(\$\_,\"$modtitle\",\"$output\"); }\n";
	    $Output{$year}{$myword}.=$regex;
	}
    }
}

print "\n";

foreach $year (sort(keys %Output)) {
    print "Year is $year\n";
    $outputfile="$outputdir"."year"."$year".".pl";
    open(OUTFILE,">$outputfile");

    # Perl line and fullcompare sub
    print OUTFILE $perl_template;

    foreach $word (keys %{ $Output{$year} }) {
	$firstletter=substr($word,0,1);
	$secondletter=substr($word,1,1);
	$wordfilepath="$inputdir"."$year/"."$firstletter/" . "$secondletter/"."$word";
#	print "$word $firstletter $secondletter $wordfilepath\n";
	# Skip if this file does not exist.  Possibly notate this somewhere.
	if (-e $wordfilepath) {
	    print OUTFILE "open(INFILE,\"$wordfilepath\");\n";
	    print OUTFILE "while (<INFILE>) {\n";
	    print OUTFILE "$Output{$year}{$word}";
	    print OUTFILE "}\n";
	    print OUTFILE "close(INFILE);\n\n";
	}
    }
    close(OUTFILE);
}

$date=`date`;
print "$date";
