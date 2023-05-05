#!/share/pkg/perl/5.24.0/install/bin/perl

sub fullcompare($unstructured,$wos_title,$output) {
    $unstructured=~s/[^a-zA-Z0-9]*//g;
    $wos_title=~s/^the //;
    $wos_title=~s/^a //;
    $wos_title=~s/^an //;
    $wos_title=~s/[^a-zA-Z0-9]*//g;

    if ($unstructured=~/$wos_title/) {
	print "$output";
    }

}

open(INFILE,"/projectnb/marxnsf1/dropbox/bigdata/nplmatch/splitpagevol/front/1955/c/conduction");
while (<INFILE>) {
#OLD	if (/\Wconwell\W/ & /\D98\D+1178\D/) { print "A1955WB09900255		1955	98	1178	conwell	$_"; }

	if (/\Wconwell\W/) { &fullcompare($_,$wos_title,$output) }

A1955WB09900255 Journal 1955    PHYSICAL REVIEW 98      4       1178           ONE PHYSICS ELLIPSE, COLLEGE PK, MD 20740-3844 USA       CONWELL, EM            Physics, Multidisciplinary       IMPURITY BAND CONDUCTION IN GERMANIUM AND SILICON
