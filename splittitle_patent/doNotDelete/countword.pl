#!/usr/local/bin/perl

require "$ENV{'NPL_BASE'}/nplmatch/config.pl";

$minlength=6;
$maxlength=20;

$year=$ARGV[0];
$infile="$INPUTDIR_PATENTS_FRONT" . "front_$year" . ".tsv";
if (!$year) { die "Usage: contword.pl YEAR\n"; }

open(INFILE,"$infile")||die("Can't open infile $infile.\n");

$linect=0;
while(<INFILE>) {
    $line=$_;

    $linect++;
    if (($linect % 10000)==0) {
#	print "At line $linect\n";
    }
    $rest=substr($line,8); # Drop the patent number
    $rest=~s/\"/ /;
    $rest=~s/-/ /;
    $rest=~s/:/ /;

    @words="";
    @words=split(/\s+/,$rest);
    foreach $word (@words) {
	$word=~s/[^a-zA-Z]*//g;
	if ((length($word)<$minlength)||(length($word)>$maxlength)) { next; }
	$WordCount{$word}++;
    }
}
close(INFILE);

foreach $key (keys %WordCount) {
    printf("%-30s %10d\n",$key,$WordCount{$key});
}
