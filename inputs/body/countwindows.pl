#!/usr/local/bin/perl

open(INFILE,"/projectnb/marxnsf1/dropbox/bigdata/nplmatch/inputs/body/1836_2004_year_output.txt");
while(<INFILE>) {
    $line=$_;
    if (!($line=~/\w/)) { next; }
    ($patent,$year)=split(/\s+/,$line);
    $patent=~s/__US-//;
    $patent=~s/-.*//;

#    print "$patent XXX $year\n";
    $Year{$patent}=$year;
}
close(INFILE);

@files=glob("windows*");
foreach $file (@files) {
    open(INFILE,"$file");
    print "Opening $file\n";
    while(<INFILE>) {
	$line=$_;
	($patent,@rest)=split(/\s+/,$line);
	$patent=~s/__US//;
#	print "$line";
#	print "$patent XX $Year{$patent}\n";
	$year=$Year{$patent};
	$WindowCount{$year}++;
    }
}

foreach $year (sort keys %WindowCount) {
    print "$year\t$WindowCount{$year}\n";
}
