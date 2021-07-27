#!/usr/local/bin/perl

$title_print="I am hungry . dog (cat) ' 053 - : \t \\ \$ elephant" ;
print "$title_print\n";

$title_print=~s/[^a-zA-Z0-9-,'.(): ]//g;
print "$title_print\n";

$title_print=~ s/[^a-zA-Z0-9]//g;
print "$title_print\n";
