#!/usr/local/bin/perl

use HTML::Entities;

#open(INFILE,"temp1");
#while(<INFILE>) {
while(<>) {
    $line=$_;
#    print "LINE: $line\n";
    &decode_entities($line);
    $line=~s/\&[a-zA-Z]*\;//g;
    $line=~s/\&\#[0-9]*\;//g;  # Added by Aaron to get rid of number denoted entities not covered by decode_entities
#    print "DECODED: $line\n";
    $line=~s/é/e/g;
    $line=~s/ä/a/g;
    $line=~s/ü/u/g;
    $line=~s/Ü/U/g;
    $line=~s/Ö/O/g;
    $line=~s/ö/o/g;
    $line=~s/Ţ/T/g;
    $line=~s/Ñ/N/g;
    $line=~s/Ż/Z/g;
    $line=~s/Ó/O/g;
    $line=~s/Ï/I/g;
    $line=~s/Ø/O/g;
    $line=~s/Ç/C/g;
    $line=~s/Ã/A/g;
    $line=~s/É/E/g;
    $line=~s/Ô/O/g;
    $line=~s/Ä/A/g;
    $line=~s/Ł/L/g;
    $line=~s/Ń/N/g;
    $line=~s/ń/n/g;
    $line=~s/ł/l/g;
    $line=~s/ř/r/g;
    $line=~s/Ź/Z/g;
    $line=~s/Ć/C/g;
    $line=~s/Â/A/g;
    $line=~s/Ą/A/g;
    $line=~s/ś/$line=~s/g;
    $line=~s/Ì/I/g;
    $line=~s/Â/A/g;
    $line=~s/Ů/U/g;
    $line=~s/ë/e/g;
    $line=~s/Ą/A/g;
    $line=~s/Á/A/g;
    $line=~s/ě/e/g;
    $line=~s/Đ/D/g;
    $line=~s/Ī/I/g;
    $line=~s/Ć/C/g;
    $line=~s/ã/a/g;
    $line=~s/Ę/E/g;
    $line=~s/Ř/R/g;
    $line=~s/C/C/g;
    $line=~s/š/$line=~s/g;
    $line=~s/È/E/g;
    $line=~s/ú/u/g;
    $line=~s/Ś/$LINE=~S/g;
    $line=~s/ś/$line=~s/g;
    $line=~s/Ķ/K/g;
    $line=~s/ª/a/g;
    $line=~s/Ë/E/g;
    $line=~s/Ă/A/g;
    $line=~s/Å/A/g;
    $line=~s/č/c/g;
    $line=~s/Ă/A/g;
    $line=~s/Ă/A/g;
    $line=~s/Æ/AE/g;
    $line=~s/ą/a/g;
    $line=~s/Ğ/G/g;
    $line=~s/À/A/g;
    $line=~s/í/i/g;
    $line=~s/ę/e/g;
    $line=~s/Ú/U/g;
    $line=~s/Č/E/g;
    $line=~s/ź/z/g;
    $line=~s/Š/$LINE=~S/g;
    $line=~s/İ/I/g;
    $line=~s/Í/I/g;
    $line=~s/Î/I/g;
    $line=~s/Ě/E/g;
    $line=~s/Š/$LINE=~S/g;
    $line=~s/Ş/$LINE=~S/g;
    $line=~s/á/a/g;
    $line=~s/ó/o/g;
    $line=~s/“/"/g;
    $line=~s/”/"/g;
    $line=~s/[^[:ascii:]]//g; # Remove any remaining non-ASCII characters
#    $line=~s/tr/\0-\177//cd; # Different way of removing non-ASCII characters

    print $line;
}
