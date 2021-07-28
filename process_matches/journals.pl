#!/usr/local/bin/perl

open(JOURNALS,"/projectnb/marxnsf1/dropbox/bigdata/nplmatch/journalabbrevs.tsv")||die("Could not open journals abbreviations file in /projectnb/marxnsf1/dropbox/bigdata/nplmatch/journalabbrevs.tsv\n");

&ReadJournals();

$journal="10th international symposium on nanostructures: physics and technology";
$line="The proceedings of p spie journal";


$value=&MatchJournal($journal,$line);


# Read in Journal Abbreviations information
sub ReadJournals {
    my($line,$journal,$abbrev);
    while(<JOURNALS>) {
	$line=$_;
	$line=~s/\n//;
	($journal,$abbrev,@rest)=split(/\t/,$line);
	if ($JournalAbbrev{$journal}) {
	    $JournalAbbrev{$journal}.="\t$abbrev";
	}
	else {
	    $JournalAbbrev{$journal}="$abbrev";
	}
    }   
}


# Match up a journal that has abbreviations
sub MatchJournal {
    my($journal,$line)=@_;
    my(@parts,$numparts,$i);

    print "$journal: $JournalAbbrev{$journal}\n\n";

    @parts=split(/\t/,$JournalAbbrev{$journal});
    $numparts=@parts;
    
    for($i=0;$i<$numparts;$i++) {
	if ($line=~/$parts[$i]/) {
	    print "Match forund for $i: $parts[$i]\n";
	}
	else {
	    print "No Match forund for $i: $parts[$i]\n";
	}
    }
}

