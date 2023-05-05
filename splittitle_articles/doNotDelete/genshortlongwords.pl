#!/usr/local/bin/perl

require "$ENV{'NPL_BASE'}/nplmatch/config.pl";

if ($ARGV[0]=~/^wos$/i) {
    $inputfile="$NPL_BASE" . "nplmatch/inputs/wos/wosplpubinfo1955-2017_filteredISS.txt";
    $sourcefilecode="wos";
}
elsif ($ARGV[0]=~/^mag$/i) {
    $inputfile="$NPL_BASE" . "nplmatch/inputs/mag/mergedmagfornpl-fixednames.tsv";    
    $sourcefilecode="mag";
}
else {
    $inputfile=$ARGV[0];
    $sourcefilecode="file";

    if (!(-e $inputfile)) {
	die("Usage: genshortlongwords.pl mag|wos|filename_or_fullpath_of_file\n");
    }
}

print "Using source file: $inputfile\n\n";

$minlength=6;
$maxlength=20;

open(INFILE,$inputfile);
# space separates patent & ref for the master NPL
# tab separates patent & ref for the yearly slices (and has the year at the end, which could create false positives

$shortlongwordsfilename="shortlongtitlewords_" . "$sourcefilecode" . ".txt";
open(SHORTLONGWORDS,">$shortlongwordsfilename");

$skipfilepath="$NPL_MISC" . "skipwords";
open(SKIPWORDSFILE,"$skipfilepath")||die("Couldn't open skipwords file $skipfilepath .\n");
while(<SKIPWORDSFILE>) {
    $word=$_;
    $word=~s/\s+//g;
    $SkipWord{$word}=1;
}
close(SKIPWORDSFILE);

$skiptitlespath="$NPL_MISC" . "badtitles.txt";
open(SKIPTITLESFILE,"$skiptitlespath")||die("Couldn't open skiptitles file $skiptitlespath .\n");
while(<SKIPTITLESFILE>) {
    $title=$_;
    $title=~s/\n//;
    $SkipTitle{$title}=1;
}
close(SKIPTITLESFILE);

$date=`date`;
print "$date";

# Go through source (WOS|MAG|FILE) file
$linect=0;
while (<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 100000)==0) {
	print "At line $linect\n";
    }

    chop($line);

    if ($line=~/^([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)\t([^\t]*)/) {
	$year = $1;
	$wosid = $2;
	$vol = $3;
	$issue = $4;
	$firstpage = $5;
	$firstauthor = $6;
	$title=$7;
	$journal=$8;
    
	$year =~ s/\///;
	$wosid =~ s/\///;
	$vol =~ s/\///;
	$issue =~ s/\///;
	$firstpage =~ s/\///;
	$firstauthor_lastname=$firstauthor;
	$firstauthor_lastname =~ tr/[A-Z]/[a-z]/;
	$firstauthor_lastname =~ s/,.*//;
	$firstauthor_lastname =~ s/\///;
	$title=~s/"//g;
	$journal=~s/"//g;

	# Skipt items with No author, "[anonymous]", author, before 1900, or after 2017
	if (($firstauthor eq "")||($firstauthor eq "[anonymous]")||($year<1900)||($year>2017)) { next; }

	# Mytitle is the version we use to split the title up in to words in the same way done in 'splitword'
	$mytitle=lc($title);
	# Skip titles in badtitles file
	if ($SkipTitle{$mytitle}) { next; }
	# Skip all titles less than 8 letters except GenBank
	if ((!("$mytitle" eq "genbank"))&&(length($mytitle)<8)) { next; }
	$mytitle=~tr/"-:;.,'/ /;

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

	if (($myword)&&(length($myword)>=2)) {
	    # Save list of short and long words
	    if ((length($myword)<$minlength)||(length($myword)>$maxlength)) { 
		print SHORTLONGWORDS "$myword\n";
	    }
	}
    }
}

$date=`date`;
print "$date";
