#!/usr/local/bin/perl

use IO::File;

$inputfile=$ARGV[0];
open(INFILE,"$inputfile")||die("Can't open input file $inputfile  Usage: breakbyearwos.pl FILE\n");

for($i=1900;$i<2020;$i++) {
    $outputfile="wosbyyear/wos_"."$i".".tsv";
    push(@OutputFiles,$outputfile);
}

my @filehandles = map { IO::File->new($_, 'w') } @OutputFiles;

while(<INFILE>) {
    $line=$_;
    ($year,@rest)=split(/\t/,$line);
    $index=$year-1900;
    if ($line) {
	$filehandles[$index]->print("$line");
    }
}
