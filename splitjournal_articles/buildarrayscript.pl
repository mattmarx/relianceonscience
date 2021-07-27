#!/usr/local/bin/perl

require "$ENV{'NPL_BASE'}/nplmatch/config.pl";

$directory="$ARGV[0]";
$frontpage_body="$ARGV[1]";
$sourcefilecode="$ARGV[2]";
$year="$ARGV[3]";

$basedir="$NPL_BASE" . "/nplmatch/" . "$directory" . "/";

$outdir="$basedir"."/arrayjob_sub_scripts/";
$outfile="$outdir" . "array-$year" . ".sh";

$bodyindictaor="";
if ($frontpage_body=~/body/) {
    $bodyindictaor="body_";
}
else {
    $bodyindictaor="front_";
}

if ((!(-e $outdir))||(!$sourcefilecode)||(!$year)) { die "Usage: buildarrayscript.pl splitjournal_articles|splitpagevol_articles|splittitle_articles frontpage|body [mag|wos|mag_lev|wos_lev] YEAR\n"; }

if ($directory=~/journal/) { $keyword="journal"; }
elsif ($directory=~/pagevol/) { $keyword="pagevol"; }
elsif ($directory=~/title/) { $keyword="title"; }

$command="ls -l $basedir" . "year_regex_scripts_" . "$bodyindictaor" . "$sourcefilecode" . "/year" . "$year" . "-* | wc -l";
$scriptcount=`$command`;
$scriptcount+=999;

open(OUTFILE,">$outfile");

print OUTFILE "#!/bin/bash -l\n\n";

print OUTFILE "#\$ -t 1000-$scriptcount\n";
print OUTFILE "#\$ -j y\n";
$line="#\$ -N run" . "$keyword" . "_" . "$bodyindictaor" . "$sourcefilecode" . "\n";
print OUTFILE "$line";
print OUTFILE "#\$ -P marxnsf1\n\n";

print OUTFILE "chmod 664 \$SGE_STDOUT_PATH\n";
print OUTFILE "chmod 664 \$SGE_STDERR_PATH\n\n";

$line="$basedir" . "year_regex_scripts_" . "$bodyindictaor" . "$sourcefilecode" . "/year" . "$year" . "-\$SGE_TASK_ID.pl > " . "$basedir" . "year_regex_output_" . "$bodyindictaor" . "$sourcefilecode" . "/year" . "$year" . "-\$SGE_TASK_ID.txt\n\n";
print OUTFILE "$line";

close(OUTFILE);



