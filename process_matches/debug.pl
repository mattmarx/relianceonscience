#!/usr/local/bin/perl

# Print format is different depending on what this is set to (0,1,2)
$debug=3;

$scoreprint=0; # Print scores >= this value unless command line arg changes this
&process_command_line();

#Allow access to the Perl Modules installed in ~aarondf/bin/perllib
use lib '/usr1/scv/aarondf/bin/perllib',
        '/usr1/scv/aarondf/bin/perllib/arch',
    '/usr1/scv/aarondf/bin/perllib/lib/perl5';
@INC = (@INC, "/usr1/scv/aarondf/bin/perllib",
              "/usr1/scv/aarondf/bin/perllib/arch",
	"/usr1/scv/aarondf/bin/perllib/lib/perl5");

use Text::Levenshtein qw(distance);

print "Using source file: $inputfile\n\n";

# 100 most common words in English.  Skip these. Also includes numbers 0-10.
open(INFILE,"/projectnb/marxnsf1/dropbox/bigdata/nplmatch/process_matches/commonwords")||die("Can'f find commonwords file.\n");
while(<INFILE>) {
    $word=$_;
    $word=~s/\n//;
    $CommonWords{$word}=1;
}

if (!$debug) {
    print "Match?\tConfidence\tVolIssPageScore\tTitleScore\tMaxTitleScore\tTitlePct\tBestTitlePct3+\tPerfectUntil\tTitleOffset\tCODE\tYEAR\tVOL\tISSUE\tFIRSTPAGE\tLASTPAGE\tFIRSTAUTHOR\tTITLE\tJOURNAL\tPatentID\tPatentLine\n";
}
open(INFILE,"$inputfile")||die("Can't open input file $inputfile\n");

while(<INFILE>) {
    $line=$_;
    $line=~s/\n//;
    ($wosid,$year,$vol,$issue,$firstpage,$lastpage,$firstauthor,$title,$journal,$patentid,$patentline,@rest)=split(/\t/,$line);

    # Backups as we will modify some things
    $vol_orig=$vol;
    $issue_orig=$issue;
    $firstpage_orig=$firstpage;
    $lastpage_orig=$lastpage;
    $title_orig=$title;
    $patentline_orig=$patentline;
    $patentline_numbers=$patentline;

    $journal=~s/[^a-zA-Z0-9_ \t&]//g;
    $journal = lc($journal)
    
    $vol=~s/[^0-9-]/ /g;
    $issue=~s/[^0-9-]/ /g;
    $firstpage=~s/[^0-9-]/ /g;
    $lastpage=~s/[^0-9-]/ /g;

    $title=~s/[^a-zA-Z0-9]/ /g;
    $patentline=~s/[^a-zA-Z0-9]/ /g;
    # Include hyphens to support volumes of the form like "2-3"
    $patentline_numbers=~s/[^0-9-]/ /g;


    @title_words=split(/\s+/,$title);
    @patent_elements=split(/\s+/,$patentline);


    # Start scoring sequence.  We are assuming YEAR and FIRSTAUTHOR have already matched so ignoring those.
    $volisspage_score=0;

    if ($vol&&$issue&&$firstpage&&($patentline_numbers=~/\D+$vol\s+$issue\s+$firstpage\D+/)) { $volisspage_score=10; }
    elsif ($vol&&$issue&&$firstpage&&($patentline_numbers=~/\D+$vol\s+\d+\s+$issue\s+$firstpage\D+/)) { $volisspage_score=9; }
    elsif ($vol&&$issue&&$firstpage&&($patentline_numbers=~/g\D+$vol\s+$issue\s+\d+\s+$firstpage\D+/)) { $volisspage_score=9; }
    else {
	if ($vol) {
	    # If line explicitly says "Vol. ##" use that as the volume and give bonus points for a match but substract
	    # heavy points for no match in this case.
	    if ($patentline_orig=~/\W+vol\.* (\d+)\D+/i) {
		$patent_vol=$1;
		if ($vol==$patent_vol) { $volisspage_score+=4; }
		else { $volisspage_score-=4; }
	    }
	    elsif ($patentline_numbers=~/\D+$vol\D+/) { $volisspage_score+=2; }
	}

	if ($issue&&($patentline_numbers=~/\D+$issue\D+/)) { $volisspage_score+=2; }

	# Extra reward for being in the form "#-#"
	if (($firstpage)&&($lastpage)) {
	    # If line explicitly says "[p]p. ##-##" use that as the first and last page and give bonus points for a match but substract
	    # heavy points for no match in this case.
	    if ($patentline_orig=~/\W+p{1,2}\.* (\d+)-(\d+)\D+/i) {
		$patent_firstpage=$1;
		$patent_lastpage=$2;
		if (($firstpage==$patent_firstpage)&&
		    ($lastpage==$patent_lastpage)) { 
		    $volisspage_score+=8; 
		}
		else { $volisspage_score-=4; }
	    }
	    # If line explicitly says "[p]p. ##" use that as the first page and give bonus points for a match but substract
	    # heavy points for no match in this case.
	    elsif ($patentline_orig=~/\W+p{1,2}\.* (\d+)\D+/i) {
		$patent_firstpage=$1;
		if ($firstpage==$patent_firstpage) { $volisspage_score+=4; }
		else { $volisspage_score-=4; }
	    }
	    # Otherwise give large bonus points for the first and last pages matching in the form "#-#"
	    elsif ($patentline_numbers=~/\D+$firstpage-$lastpage\D+/) { $volisspage_score+=8; }
	    # Handles the case where the patent line says something like 4427-37 when it really means 4437 as the last page
	    elsif (($patentline_numbers=~/\D+$firstpage-(\d+)\D+/)&& 
		   ($lastpage=~/$1$/))
		   { $volisspage_score+=4; }
	    else {
		if ($patentline_numbers=~/\D+$firstpage\D+/) { $volisspage_score+=2; }
		if (($firstpage!=$lastpage)&&($patentline_numbers=~/\D+$lastpage\D+/)) { $volisspage_score+=2; }
	    }
	}
	elsif ($firstpage) {
	    # If line explicitly says "[p]p. ##" use that as the first page and give bonus points for a match but substract
	    # heavy points for no match in this case.
	    if ($patentline_orig=~/\W+p{1,2}\.* (\d+)\D+/i) {
		$patent_firstpage=$1;
		if ($firstpage==$patent_firstpage) { $volisspage_score+=4; }
		else { $volisspage_score-=4; }
	    }
	    # Otherwise give bonus points for the page matching in the form "#-"
	    elsif ($patentline_numbers=~/\D+$firstpage-\d+/) { $volisspage_score+=4; }
	    elsif ($patentline_numbers=~/\D+$firstpage-\D+/) { $volisspage_score+=2; }
	}

	# Penalize things where some or all of the vol, issue, and page are the same number as one match then gives two or three for free.
	if (($vol==$issue)&&($issue==$firstpage)) { $volisspage_score-=4; }
	elsif (($vol==$issue)||($issue==$firstpage)||($vol==$firstpage)) { $volisspage_score-=2; }
    }

    # Figure out journal score
    # Likely want to expand this so to give some credit for "cancer research" vs "cancer res." and similar cases.
    $journal_score=0;
    if ($patentline_orig=~/\W+$journal\W+/) {
	$journal_score=1;
    }

    # Figure out title score
    $title_score=0;
    $numwords=@title_words;
    $most_common_difference="";
    undef %numdifferences;
    for($wordct=0;$wordct<$numwords;$wordct++) {
	$word=$title_words[$wordct];
	$index[$wordct]=&mymemberindex($word,@patent_elements);
	if ($CommonWords{$word}) {
	    $common[$wordct]=1;
	}
	else {
	    $common[$wordct]=0;
	}
	if ($index[$wordct]) {
	    $difference[$wordct]=$index[$wordct]-$wordct;
	    $numdifferences{$difference[$wordct]}++;
	}
#	print "Word: $word Common: $common[$wordct] Diff: $difference[$wordct]\n";
    }


    $mostcommondifference=0;
    $occurrences=0;
    foreach $difference (keys %numdifferences) {
#	print "Diff: $difference Number: $numdifferences{$difference}\n";
	if ($numdifferences{$difference}>$occurrences) {
	    $mostcommondifference=$difference;
	    $occurrences=$numdifferences{$difference};
	}
    }

    $maxtitle_score=$numwords*4;
    $perfectuntil=0;
    $bestpercent=0;
    for($wordct=0;$wordct<$numwords;$wordct++) {
	$word=$title_words[$wordct];

	if ($index[$wordct]) {
	    # Give 4 points for uncommon matching word in matching position
	    # Give 2 points for common word in matching position
	    # Give 2 points for uncommon word found anywhere
	    # Give 0 points for common word found in non-matching position
	    if (($common[$wordct]==0)&&($difference[$wordct]==$mostcommondifference)) { $title_score+=4; }
	    elsif ($difference[$wordct]==$mostcommondifference) { $title_score+=2; }
	    elsif ($common[$wordct]==0) { $title_score+=2; }
	}
	else {
	    # Give 3 points to Levenshtein Distance 1 uncommon words (the word we are comparing to is the word in the most common offset position)
	    if (($common[$wordct]==0)&&($patent_elements[$mostcommondifference+$wordct-1])) {
		$num=$mostcommondifference+$wordct;
		$distance=distance($word,$patent_elements[$mostcommondifference+$wordct-1]);
		if ($distance==1) { $title_score+=3; }
#		print "Distance from $word to $patent_elements[$mostcommondifference+$wordct-1] is $distance - MCD: $mostcommondifference Wordct: $wordct Num: $num\n";
	    }
	}
	if (($title_score/(($wordct+1)*4))==1) { $perfectuntil=$wordct+1; }
	# Starting with word 4 of the title, compute the best percentage of maximum possible score achieved so far. Keep track of the highest value of this.
	if (($wordct>=3)&&(($title_score/(($wordct+1)*4))>$bestpercent)) { 
	    $bestpercent=$title_score/(($wordct+1)*4); 
	}
    }

    if ($maxtitle_score) { 
	$percentage=$title_score/$maxtitle_score*100;
    }
    else {
	$percentage=0.0;
    }
    $bestpercent*=100;
    $print=0;
    $confidence=0;
    # Perfect or nearly perfect VolIssPage match AND excellent title score
    if (($volisspage_score>=9)&&(($percentage>60)||($bestpercent>=75))) {
	$confidence=9;
    }
    # Nearly perfect VolIssPage match OR excellent title score
    elsif (($volisspage_score>=9)||(($percentage>60)||($bestpercent>=75))) {
	$confidence=8;
    }
    # Two of Vol Iss Page and fairly good title match OR
    # All of Vol Iss Page (but not in order) and ok title match
    elsif ((($volisspage_score>=4)&&(($percentage>40)||($bestpercent>50)))|| 
	   (($volisspage_score>=6)&&(($percentage>35)||($bestpercent>40)))) { 
	$confidence=6;
    }
    # One of Vol Iss Page and fairly good title match
    # Vol Iss Page score of 6+
    elsif ((($volisspage_score>=2)&&(($percentage>40)||($bestpercent>50)))||
	   ($volisspage_score>=6)){ 
	$confidence=4;
    }
    # Fairly good title match
    elsif ((($percentage>40)||($bestpercent>50))||
	   ($volisspage_score>=4)) { 
	$confidence=3;
    }

    # Give 1 point for journal match.  Add it to whatever combined confidence figured above.
    if ($journal_score>=1) { $confidence++; }


    # Match if meets any of these strong criteria
    if ($confidence>=9) {
	$string="MATCH     "; 
    }
    elsif ($confidence>=8) {
	$string="MATCH     "; 
    }
    elsif ($confidence>=7) {
	$string="MATCH     "; 
    }
    elsif ($confidence>=6) {
	$string="??? MATCH "; 
    }
    elsif ($confidence>=5) {
	$string="??? MATCH "; 
    }
    elsif ($confidence>=4) { 
	$string="NO MATCH  "; 
    }
    elsif ($confidence>=3) { 
	$string="NO MATCH  "; 
    }
    else { 
	$string="NO MATCH  "; 
    }

    if ($confidence>=$scoreprint) {
	$print=1;
    }
    else {
	$print=0;
    }

    if ($print) {
	if ($debug) {
	    print "$string";
	    printf("CONF: %d VIP_S: %d T_S: %3d M_TS: %3d PCT: %5.2f BESTPCT: %5.2f PU: %2d TITLE_OFFSET: %d\n",$confidence, $volisspage_score,$title_score,$maxtitle_score,$percentage,$bestpercent,$perfectuntil,$mostcommondifference-1);
	    print "WOSID: $wosid VOL: $vol ISS: $issue FPAGE: $firstpage LPAGE: $lastpage TITLE: $title_orig \tJOURNAL: $journal\n";
	    print "PATENT: $patentid PATENTLINE: $patentline_orig\n";
	    if ($debug>=2) {
#		print "$vol\t$issue\t$firstpage\t$title_orig\t$journal\n";
#		print "$patentline_orig\n";
#		print "NUMS: $patentline_numbers\n";
#		print "$volisspage_score\n\n";
	    }
	    if ($debug>=3) {
		print "$line\n";
	    }
	    print "\n";
	}
	else {
	    printf("%s\t%d\t%d\t%3d\t%3d\t%5.2f\t%5.2f\t%2d\t%d\t%s\n",$string,$confidence, $volisspage_score,$title_score,$maxtitle_score,$percentage,$bestpercent,$perfectuntil,$mostcommondifference-1,$line);
	}
    }
}

sub process_command_line {
    local($i,$j,$k);

    $numargs=@ARGV;

    $retval=1;
    if ($numargs==0) {
        &print_usage();
    }

    for($i=0;$i<$numargs;$i++) {
        if ($ARGV[$i]=~/^-print/) {
            if ($ARGV[($i+1)]=~/^\d+$/) {
                $scoreprint=$ARGV[($i+1)];
                $i++;
		print "here\n";
            }
            else {
		print "No score minimum given with -print argument\n";
                &print_usage();
            }
        }
	else {
	    $inputfile=$ARGV[$i];
	}
    }
    if (!(-e $inputfile)) {
	die("Usage: score_matches.pl filename_or_fullpath_of_file\n");
    }
}

sub print_usage {
    die "Usage: score_matches.pl [-printscore 1-10] filename\n";
}


# SEE IF AN ITEM IS PART OF AN ARRAY AND RETURN ITS INDEX NUMBER +1.  RETURN 0 IF NOT FOUND.
sub mymemberindex {
    my($matchitem,@myarray)=@_;
    my($numitems,$retval,$i);
    $retval=0;

    $numitems=@myarray;
    for($i=0;$i<$numitems;$i++) {
        if (($myarray[$i])&&("$matchitem" eq "$myarray[$i]")) {
            $retval=$i+1;
            $i=$numitems;
        }
    }

    $retval;
}

