#!/usr/local/bin/perl

open(INFILE,"wosplpubinfo1955-2017_filtered.txt");

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
	# Skip titles in badtitles file
	if ($SkipTitle{$mytitle}) { next; }
	# Skip all titles less than 8 letters except GenBank
	if ((!("$mytitle" eq "genbank"))&&(length($mytitle)<8)) { next; }
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

	    # Avoid very common words
	    if ($SkipWord{$word}) { next; }

	    if (length($word)>$longest) {
		$longest=length($word);
		$myword=$word;
	    }

	    $prevword=$word;
	}

	if (length($myword)==2) {
	    print "$title\n";
	}
    }
}

